defmodule F4Hack.Hacker do
  @moduledoc """
  Documentation for F4Hack.Hacker.
  """


  def process_input(input) do
    input
      |> String.upcase
      |> String.split
      |> Enum.map(&String.graphemes/1)
  end

  def calculate_likenesses(word, words) do
    likenesses = words
      |> Stream.filter(&(&1 != word))
      |> Stream.map(&({Enum.join(&1), calculate_likeness(&1, word)}))
      |> Enum.to_list

    {Enum.join(word), likenesses}
  end

  def calculate_likeness(a, b) do
    Enum.zip(a, b)
      |> Enum.filter(fn({a, b}) -> a == b end)
      |> Enum.count
  end
end
