defmodule F4Hack.Hacker do
  @moduledoc """
  Documentation for F4Hack.Hacker.
  """


  def process_input(input) do
    input
      |> String.upcase
      |> String.split
  end

  def calculate_all_likenesses(words) do
    new_words = words
      |> Enum.map(&String.graphemes/1)

      new_words
      |> Enum.map(&calculate_likenesses(&1, new_words))
  end

  def calculate_likenesses(word, words) do
    likenesses = words
      |> Stream.filter(&(&1 != word))
      |> Enum.reduce(%{}, fn x, acc ->
        likeness = calculate_likeness(x, word)
        value = [Enum.join(x)]
        Map.update(acc, likeness, value, &(&1 ++ value))
      end)

    likenesses = likenesses
      |> Map.keys
      |> Enum.reduce(%{}, fn key, acc ->
        Map.put(acc, key, calculate_all_likenesses(likenesses[key]))
      end)

    {Enum.join(word), likenesses}
  end

  def calculate_likeness(a, b) do
    Enum.zip(a, b)
      |> Enum.filter(fn {a, b} -> a == b end)
      |> Enum.count
  end

  def max_depth({_, map}) when map == %{}, do: 1
  def max_depth({_, map}) do
    depth = map
      |> Map.keys
      |> Enum.map(fn key ->
        map[key]
          |> Enum.map(fn m ->
            max_depth(m)
          end)
          |> Enum.max
        end)
      |> Enum.max

    depth + 1
  end

  def make_best_guess(likenesses) do
    {best_guess, _} = likenesses
      |> Enum.map(fn {word, _} = likeness ->
        {word, max_depth(likeness)}
      end)
      |> Enum.sort(fn {_, a}, {_, b} -> a <= b end)
      |> hd
    best_guess
  end

  def make_guess(likenesses, guess) do
    {_, map} = likenesses
      |> Enum.find(fn {word, _} -> word == guess end)
    map
  end

  def get_remaining_words(map, likeness) do
    map[likeness]
      |> Enum.map(fn {word, _} -> word end)
      |> Enum.join(", ")
  end
end
