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
      |> Enum.reduce(%{}, fn x, acc ->
        likeness = calculate_likeness(x, word)
        value = [Enum.join(x)]
        Map.update(acc, likeness, value, &(&1 ++ value))
      end)

    {Enum.join(word), likenesses}
  end

  def calculate_likeness(a, b) do
    Enum.zip(a, b)
      |> Enum.filter(fn {a, b} -> a == b end)
      |> Enum.count
  end

end
