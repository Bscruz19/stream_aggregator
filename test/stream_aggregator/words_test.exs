defmodule StreamAggregator.WordsTest do
  use ExUnit.Case

  alias StreamAggregator.Words

  describe "frequencies/1" do
    test "returns a map of words frequencies" do
      words = ["Mob", "Psycho", "100", "Mob", "Psycho", "100", "Mob"]

      assert %{"Mob" => 3, "Psycho" => 2, "100" => 2} = Words.frequencies(words)
    end
  end

  describe "merge/1" do
    test "returns a merged map" do
      words1 = %{"Over" => 3, "the" => 2, "garden" => 2, "wall" => 1}
      words2 = %{"Over" => 3, "the" => 2, "garden" => 2}

      assert %{"Over" => 6, "the" => 4, "garden" => 4, "wall" => 1} = Words.merge(words1, words2)
      assert Words.merge(words1, %{}) == words1
    end
  end

  describe "most_frequent/1" do
    test "returns the most frequent word" do
      words = %{"The" => 3, "midnight" => 10, "gospel" => 2}

      assert {"midnight", 10} = Words.most_frequent(words)
    end

    test "returns nil when the map is empty" do
      refute Words.most_frequent(%{})
    end
  end
end
