defmodule StreamAggregator do
  @moduledoc false

  use Application

  alias StreamAggregator.{Router, Server, SocketHandler}

  def start(_type, _args) do
    children = [
      Supervisor.child_spec({Server, %{}}, restart: :permanent),
      {Task.Supervisor, name: Server.TaskSupervisor},
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Router,
        options: [dispatch: dispatch(), port: web_port()]
      ),
      Registry.child_spec(keys: :duplicate, name: Registry.StreamAggregator)
    ]

    opts = [strategy: :one_for_one, name: StreamAggregator.Supervisor]

    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
       [
         {"/", SocketHandler, []},
         {:_, Plug.Cowboy.Handler, {Router, []}}
       ]}
    ]
  end

  defp web_port do
    :stream_aggregator
    |> Application.get_env(:web_port)
    |> String.to_integer()
  end
end
