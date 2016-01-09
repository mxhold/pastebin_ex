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

  test "posting and getting a paste" do
    conn = conn(:post, "/", "hello world!")

    conn = AppRouter.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 201

    url = conn.resp_body
    uuid = "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"
    base_url = Regex.escape("http://www.example.com/")
    url_regex = Regex.compile!("#{base_url}#{uuid}")
    assert Regex.match?(url_regex, url)

    paste_name = String.split(url, "/") |> List.last
    conn = conn(:get, "/#{paste_name}")

    conn = AppRouter.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "hello world!"
  end

  test "invalid paste name returns 404" do
    conn = conn(:get, "/foo")

    conn = AppRouter.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "nonexistant paste returns 404" do
    conn = conn(:get, "/3cdf55b6-2ffe-42c9-97be-d94ef66e58c6")

    conn = AppRouter.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
