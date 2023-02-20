# frozen_string_literal: true

require "base64"
require "net/http"
require "json"

module SurrealDB
  module Clients
    # HTTP client for the SurrealDB
    class HTTP
      ENDPOINT = "/sql"

      # Parameters:
      #   uri: String
      #     The URI of the SurrealDB server
      #     Example: "http://user:password@localhost:8080/namespace/database"
      def initialize(uri)
        @connected = false
        @uri = URI(uri)

        # Parse the namespace and database from the URI
        @namespace, @database = @uri.path.split("/")[1..2]

        @username = @uri.user
        @password = @uri.password

        # Set the path to the SQL endpoint
        @uri.path = ENDPOINT

        @connection = Net::HTTP.new(@uri.host, @uri.port)
      end

      def connect
        @connection.start
        @connected = true

        # Ping the server to check if the connection is established
        execute("INFO FOR DB").success?
      rescue Error
        @connected = false
      end

      def disconnect
        @connection.finish
        @connected = false
      end

      def execute(query)
        connect unless connected?

        request = Net::HTTP::Post.new(@uri.path, headers).tap { |r| r.body = query }
        response = @connection.request(request)

        raise Error, format_error(response) unless (200..300).include?(response.code.to_i)

        Response.new(parse_json_body(response).first)
      end

      def connected?
        @connected
      end

      private

      def headers
        @headers ||= {
          "User-Agent" => "SurrealDB Ruby Client #{SurrealDB::VERSION}",
          "Accept" => "application/json",
          "Authorization" => "Basic #{Base64.strict_encode64("#{@username}:#{@password}")}",
          "Content-Type" => "application/x-www-form-urlencoded",
          "NS" => @namespace,
          "DB" => @database
        }
      end

      def format_error(response)
        json = parse_json_body(response)

        "Query failed with status code #{response.code}\n" \
          "details: #{json["details"]}\n" \
          "information: #{json["information"]}\n" \
          "description: #{json["description"]}"
      end

      def parse_json_body(response)
        JSON.parse(response.body)
      rescue JSON::ParserError
        raise Error, "Invalid JSON response from SurrealDB: #{response.body}"
      end
    end
  end
end
