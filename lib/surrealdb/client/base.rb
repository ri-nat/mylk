# frozen_string_literal: true

module SurrealDB
  module Client
    # Base class for SurrealDB clients
    class Base
      attr_accessor :uri, :username, :password, :namespace, :database

      # Parameters:
      #   uri: String
      #     The URI of the SurrealDB server
      #     Example: "http://user:password@localhost:8080/namespace/database"
      def initialize(uri)
        parse_connection_params(uri)
      end

      def connect
        raise NotImplementedError
      end

      def disconnect
        raise NotImplementedError
      end

      def connected?
        !!@connected
      end

      private

      def endpoint_path
        raise NotImplementedError
      end

      def endpoint_scheme
        raise NotImplementedError
      end

      def parse_connection_params(url) # rubocop:disable Metrics/AbcSize
        self.uri = URI(url)
        self.username = uri.user
        self.password = uri.password
        self.namespace, self.database = uri.path.split("/")[1..2]
        uri.path = endpoint_path
        uri.scheme = endpoint_scheme
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
