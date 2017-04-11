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
        case acc[likeness] do
          nil ->
            Map.put(acc, likeness, [Enum.join(x)])

          arr ->
            %{acc | likeness => arr ++ [Enum.join(x)]}
        end
      end)

    {Enum.join(word), likenesses}
  end

  def calculate_likeness(a, b) do
    Enum.zip(a, b)
      |> Enum.filter(fn {a, b} -> a == b end)
      |> Enum.count
  end
end
