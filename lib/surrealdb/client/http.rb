# frozen_string_literal: true

require "base64"
require "net/http"
require "json"

require_relative "base"

module SurrealDB
  module Client
    # HTTP client for the SurrealDB
    class HTTP < Base
      def initialize(url)
        super

        @connection = Net::HTTP.new(uri.host, uri.port)
        # Mutex to prevent multiple threads from using the same connection
        @mutex = Mutex.new
      end

      def connect
        return true if connected?

        @mutex.synchronize do
          @connection.start
          @connected = true
        end

        # Ping the server to check if the connection is established
        execute("INFO FOR DB").success?
      rescue Error
        disconnect
      end

      def disconnect
        return if disconnected?

        @mutex.synchronize do
          @connection.finish
          @connected = false
        end
      end

      def execute(query) # rubocop:disable Metrics/AbcSize
        connect if disconnected?

        request = Net::HTTP::Post.new(uri.path, headers).tap { |r| r.body = query }
        response = @mutex.synchronize { @connection.request(request) }

        raise Error, format_error(response) unless (200..300).include?(response.code.to_i)

        Response.new(parse_json_body(response).first)
      end

      private

      def endpoint_path
        "/sql"
      end

      def endpoint_scheme
        "http"
      end

      def headers
        @headers ||= {
          "User-Agent" => "SurrealDB Ruby Client #{SurrealDB::Client::VERSION}",
          "Accept" => "application/json",
          "Authorization" => "Basic #{Base64.strict_encode64("#{username}:#{password}")}",
          "Content-Type" => "application/x-www-form-urlencoded",
          "NS" => namespace,
          "DB" => database
        }
      end
    end
  end
end
