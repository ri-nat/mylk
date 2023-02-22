# frozen_string_literal: true

module Mylk
  # Response from the SurrealDB
  class Response
    attr_reader :result, :status, :time

    def initialize(response)
      @result = response["result"]
      @status = response["status"]
      @time = response["time"]
    end

    def success?
      @status == "OK"
    end

    def error?
      !success?
    end
  end
end
