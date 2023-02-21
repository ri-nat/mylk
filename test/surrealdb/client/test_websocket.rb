# frozen_string_literal: true

require "test_helper"
require "surrealdb/client/websocket"

class TestWebsocket < Minitest::Test
  DATABASE_URL = ENV.fetch("DATABASE_URL", "surrealdb://root:root@localhost:8000/test/test")

  def test_it_connects_to_surrealdb
    assert SurrealDB::Client::Websocket.new(DATABASE_URL).connect
  end

  def test_it_executes_successfully
    client = SurrealDB::Client::Websocket.new(DATABASE_URL).tap(&:connect)

    assert client.execute("INFO FOR DB").success?
  end

  def test_it_connects_automatically_on_execute
    assert SurrealDB::Client::Websocket.new(DATABASE_URL).execute("INFO FOR DB").success?
  end
end