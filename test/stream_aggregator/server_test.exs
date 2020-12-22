defmodule StreamAggregator.ServerTest do
  use ExUnit.Case

  alias StreamAggregator.Server

  setup do
    on_exit(fn ->
      :sys.replace_state(Server, fn _state -> %{socket: nil, words: %{}} end)
    end)

    :ok
  end

  describe "aggregate/2" do
    test "adds a word frequency map to the server state" do
      words = %{"Ricky" => 3, "and" => 2, "Morty" => 2}

      Server.aggregate("Ricky and Morty Ricky and Morty Ricky")

      assert %{words: ^words} = :sys.get_state(Server)
    end
  end

  describe "words_notification/2" do
    test "adds the websocket pid to the server state and receives a word notification" do
      pid = self()
      Server.aggregate("Persépolis Persépolis Persépolis Persépolis Maus Habbib From hell")

      Server.words_notification(pid)

      receive do
        message ->
          assert message == "Persépolis: 4"
      end

      assert %{socket: ^pid} = :sys.get_state(Server)
    end
  end

  describe "most_frequent_word/1" do
    test "returns the most frequent word" do
      Server.aggregate("Sheep in the big city Sheep")

      assert {"Sheep", 2} = Server.most_frequent_word()
    end
  end
end
