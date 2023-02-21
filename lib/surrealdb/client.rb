# frozen_string_literal: true

require_relative "client/response"
require_relative "client/version"

module SurrealDB
  module Client
    class Error < StandardError; end
  end
end
