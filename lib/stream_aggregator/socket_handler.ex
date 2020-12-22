defmodule StreamAggregator.SocketHandler do
  @moduledoc false

  @behaviour :cowboy_websocket

  alias StreamAggregator.Server

  def init(request, _state) do
    state = %{registry_key: request.path}

    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Registry.register(Registry.StreamAggregator, state.registry_key, {})

    Server.words_notification(self())

    {:ok, state}
  end

  def websocket_handle({:text, text}, state) do
    Server.aggregate(text)

    {:ok, state}
  end

  def websocket_info(info, state), do: {:reply, {:text, info}, state}
end
