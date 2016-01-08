defmodule PastebinEx do
  defmodule AppRouter do
    use Plug.Router

    plug :match
    plug :dispatch

    get "/" do
      base_url = "#{conn.scheme}://#{conn.host}"
      page_contents = EEx.eval_file("lib/views/usage.html.eex", [base_url: base_url])
      send_resp(conn, 200, page_contents)
    end

    match _ do
      send_resp(conn, 404, "404")
    end
  end
end
