defmodule StreamAggregator.Words do
  @moduledoc false

  def frequencies(words), do: Enum.frequencies(words)

  def merge(words1, words2),
    do: Map.merge(words1, words2, fn _k, quantity1, quantity2 -> quantity1 + quantity2 end)

  def most_frequent(words) do
    if not Enum.empty?(words), do: Enum.max_by(words, fn {_k, quantity} -> quantity end)
  end
end
