# frozen_string_literal: true

require_relative "surrealdb/clients/http"
require_relative "surrealdb/clients/ws"
require_relative "surrealdb/response"
require_relative "surrealdb/version"

module SurrealDB
  class Error < StandardError; end
end
