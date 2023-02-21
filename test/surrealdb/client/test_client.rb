# frozen_string_literal: true

require "test_helper"

class TestClient < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SurrealDB::Client::VERSION
  end
end
