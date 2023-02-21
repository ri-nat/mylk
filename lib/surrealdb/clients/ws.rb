# frozen_string_literal: true

require "websocket-client-simple"

require_relative "base"

module SurrealDB
  module Clients
    # Websocket client for the SurrealDB
    class Websocket < Base
      WAIT_SLEEP_DURATION = 0.001 # 1 millisecond
      CONNECTION_TIMEOUT = 2 # 2 seconds
      REQUEST_TIMEOUT = 2 # 2 seconds

      def initialize(url)
        super

        @connection = nil
        # Mutex to synchronize the access to the requests hash
        @mutex = Mutex.new
        @requests = {}
      end

      def connect
        @connection = WebSocket::Client::Simple.connect(uri.to_s, headers: headers)

        attach_on_message_handler
        wait_for_connection_establishment

        @connected = true

        # Authenticate and select the database
        call_rpc("signin", [{ user: username, pass: password }])
        call_rpc("use", [namespace, database])

        # Ping the server to check if the connection is established
        execute("INFO FOR DB").success?
      end

      def disconnect
        return unless connected?

        @connection.close
        @connected = false
      end

      def execute(query)
        Response.new(call_rpc("query", [query]))
      end

      private

      def call_rpc(method, params)
        raise Error, "Not connected to SurrealDB" unless connected? || connect

        request_id = SecureRandom.uuid
        @connection.send({ id: request_id, method: method, params: params }.to_json)

        Timeout.timeout(REQUEST_TIMEOUT) do
          sleep WAIT_SLEEP_DURATION until @mutex.synchronize { @requests[request_id] }
        end

        @mutex.synchronize { @requests.delete(request_id) }
      rescue Timeout::Error
        raise Error, "Request to SurrealDB timed out"
      end

      def add_message(parsed)
        @mutex.synchronize do
          @requests[parsed["id"]] = parsed["result"].is_a?(Array) ? parsed["result"].first : true
        end
      end

      def attach_on_message_handler
        am = method(:add_message)

        @connection.on :message do |msg|
          next if msg.data == ""

          am.call(JSON.parse(msg.data))
        end
      end

      def wait_for_connection_establishment
        connected = false
        @connection.on :open do
          connected = true
        end

        # If the connection became opened before the handler was attached, we need to check it
        connected ||= @connection.open?

        Timeout.timeout(CONNECTION_TIMEOUT) do
          sleep WAIT_SLEEP_DURATION until connected
        end
      rescue Timeout::Error
        raise Error, "Connection to SurrealDB timed out"
      end

      def endpoint_path
        "/rpc"
      end

      def endpoint_scheme
        "ws"
      end

      def headers
        {
          "User-Agent" => "SurrealDB Ruby Client #{SurrealDB::VERSION}"
        }
      end
    end
  end
end
