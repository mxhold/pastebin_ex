defmodule PastebinEx do
  defmodule AppRouter do
    use Plug.Router

    plug :match
    plug :dispatch

    get "/" do
      send_resp(conn, 200, "hello")
    end
  end
end
