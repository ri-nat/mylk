# frozen_string_literal: true

require "test_helper"

class TestSurrealDB < Minitest::Test
  DATABASE_URI = "http://root:root@localhost:8808/test/test"

  def test_it_connects_to_surrealdb
    assert SurrealDB::Clients::HTTP.new(DATABASE_URI).connect
  end

  def test_it_executes_successfully
    client = SurrealDB::Clients::HTTP.new(DATABASE_URI).tap(&:connect)

    assert client.execute("INFO FOR DB").success?
  end

  def test_it_connects_automatically_on_execute
    assert SurrealDB::Clients::HTTP.new(DATABASE_URI).execute("INFO FOR DB").success?
  end
end
