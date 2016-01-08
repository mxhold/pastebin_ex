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
      base_url = "#{conn.scheme}://#{conn.host}:#{conn.port}"
      page_contents = EEx.eval_file("lib/views/usage.html.eex", [base_url: base_url])
      send_resp(conn, 200, page_contents)
    end

    match _ do
      send_resp(conn, 404, "404")
    end
  end
end
