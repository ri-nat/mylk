# frozen_string_literal: true

require "test_helper"
require "mylk/websocket"

class TestWebSocket < Minitest::Test
  DATABASE_URL = ENV.fetch("DATABASE_URL", "surreal://root:root@localhost:8000/test/test")

  def test_it_connects_to_surrealdb
    assert Mylk::WebSocket.new(DATABASE_URL).connect
  end

  def test_it_executes_successfully
    client = Mylk::WebSocket.new(DATABASE_URL).tap(&:connect)

    assert client.execute("INFO FOR DB").success?
  end

  def test_it_connects_automatically_on_execute
    assert Mylk::WebSocket.new(DATABASE_URL).execute("INFO FOR DB").success?
  end
end
