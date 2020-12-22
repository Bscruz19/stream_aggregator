defmodule StreamAggregatorWeb.Server do
  @moduledoc false

  use GenServer

  @notification_time Application.get_env(:stream_aggregator, :notification_time)

  alias StreamAggregator.Words

  def start_link(_state, opts \\ []) do
    server_name = opts[:server_name] || __MODULE__

    GenServer.start_link(server_name, %{socket: nil, words: %{}}, name: __MODULE__)
  end

  def init(state), do: {:ok, state}

  def aggregate(text, opts \\ []) do
    server_name = opts[:server_name] || __MODULE__

    GenServer.cast(server_name, {:aggregate, text})
  end

  def words_notification(socket, opts \\ []) do
    server_name = opts[:server_name] || __MODULE__

    GenServer.cast(server_name, {:words_notification, socket})
  end

  def most_frequent_word(opts \\ []) do
    server_name = opts[:server_name] || __MODULE__

    GenServer.call(server_name, :most_frequent_word)
  end

  def handle_call(:most_frequent_word, _from, %{words: words} = state) do
    {:reply, Words.most_frequent(words), state}
  end

  def handle_cast({:aggregate, text}, %{words: words} = state) do
    state = %{state | words: aggregate_words(words, text)}

    {:noreply, state}
  end

  def handle_cast({:words_notification, socket}, state) do
    {:ok, _pid} =
      Task.Supervisor.start_child(__MODULE__.TaskSupervisor, fn ->
        words_notification_worker(socket)
      end)

    {:noreply, Map.put(state, :socket, socket)}
  end

  defp aggregate_words(state, text) do
    text
    |> String.split(" ")
    |> Words.frequencies()
    |> Words.merge(state)
  end

  defp words_notification_worker(socket) do
    :timer.sleep(@notification_time)

    word = most_frequent_word()

    if word, do: send(socket, "#{elem(word, 0)}: #{elem(word, 1)}")

    words_notification_worker(socket)
  end
end
