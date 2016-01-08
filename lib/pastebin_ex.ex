defmodule PastebinEx do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(__MODULE__, [], function: :run)
    ]

    opts = [strategy: :one_for_one, name: PastebinEx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def run do
    {:ok, _} = Plug.Adapters.Cowboy.http PastebinEx.AppRouter, []
  end

  defmodule AppRouter do
    use Plug.Router

    plug :match
    plug :dispatch

    get "/" do
      page_contents = EEx.eval_file("lib/views/usage.html.eex", [base_url: base_url(conn)])
      send_resp(conn, 200, page_contents)
    end

    post "/" do
      send_resp(conn, 201, "#{base_url(conn)}/3cdf55b6-2ffe-42c9-97be-d94ef66e58c6")
    end

    get "/3cdf55b6-2ffe-42c9-97be-d94ef66e58c6" do
      send_resp(conn, 200, "hello world!")
    end

    match _ do
      send_resp(conn, 404, "404")
    end

    def base_url(conn) do
      port_part = if conn.port == 80 do "" else ":#{conn.port}" end
      "#{conn.scheme}://#{conn.host}#{port_part}"
    end
  end
end
