defmodule PastebinExTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest PastebinEx

  alias PastebinEx.AppRouter

  @opts AppRouter.init([])

  test "display usage" do
    conn = conn(:get, "/")

    conn = AppRouter.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "hello"
  end
end
