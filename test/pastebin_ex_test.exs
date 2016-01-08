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
    assert conn.resp_body == """
<pre>
Usage:

  $ echo \"hello, world\" | curl http://www.example.com --data-binary @-
  http://www.example.com/3cdf55b6-2ffe-42c9-97be-d94ef66e58c6

  $ curl http://www.example.com/3cdf55b6-2ffe-42c9-97be-d94ef66e58c6
  hello, world
</pre>
"""
  end
end
