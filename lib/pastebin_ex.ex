defmodule PastebinEx do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(PastebinEx.Repo, []),
      worker(__MODULE__, [], function: :run)
    ]

    opts = [strategy: :one_for_one, name: PastebinEx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def run do
    {:ok, _} = Plug.Adapters.Cowboy.http PastebinEx.AppRouter, []
  end

  defmodule Repo do
    use Ecto.Repo, otp_app: :pastebin_ex
  end

  defmodule Paste do
    use Ecto.Schema

    @primary_key {:name, :binary_id, autogenerate: true}

    schema "pastes" do
      field :body
      timestamps
    end

    def insert(body: body) do
      Repo.insert(%Paste{body: body})
    end

    def fetch(name) do
      with {:ok, name} <- Ecto.UUID.cast(name),
           {:ok, paste} <- do_fetch(name),
           do: {:ok, paste}
    end

    defp do_fetch(name) do
      case Repo.get(__MODULE__, name) do
        nil -> :error
        paste -> {:ok, paste}
      end
    end
  end

  defmodule AppRouter do
    use Plug.Router

    plug :match
    plug :dispatch

    get "/" do
      page_contents = EEx.eval_file(
        "lib/views/usage.html.eex",
        [base_url: base_url(conn)]
      )
      send_resp(conn, 200, page_contents)
    end

    post "/" do
      {:ok, body, _} = Plug.Conn.read_body(conn)
      {:ok, paste} = Paste.insert(body: body)
      send_resp(conn, 201, "#{base_url(conn)}/#{paste.name}")
    end

    match "/:name" do
      case Paste.fetch(name) do
        {:ok, paste} ->
          conn
          |> put_resp_content_type("text/plain")
          |> send_resp(200, paste.body)
        :error -> not_found(conn)
      end
    end

    match _ do
      not_found(conn)
    end

    def not_found(conn) do
      send_resp(conn, 404, "404")
    end

    def base_url(conn) do
      port_part = if conn.port == 80 do "" else ":#{conn.port}" end
      "#{conn.scheme}://#{conn.host}#{port_part}"
    end
  end
end
