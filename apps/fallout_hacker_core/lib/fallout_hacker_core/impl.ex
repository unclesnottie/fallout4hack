defmodule FalloutHacker.Core.Impl do
  @moduledoc """
  Documentation for FalloutHacker.Core.Impl.
  """

  alias FalloutHacker.Core.Attempt

  def initialize_word_list(words) do
    word_list = words
    |> String.upcase
    |> String.split

    word_length = word_list
    |> hd
    |> String.length

    if Enum.all?(word_list, fn(w) -> String.length(w) == word_length end) do
      {:ok, %Attempt{words: word_list, length: word_length}}
    else
      {:error, :unequal_length}
    end
  end

  def get_guess(state = %Attempt{words: [password]}) do
    %{state | guess: password, password: password}
  end

  def get_guess(state = %Attempt{guess: nil, words: word_list}) do
    best_guess = best_guess(word_list)
    new_word_list = word_list -- [best_guess]
    %{state | guess: best_guess, words: new_word_list}
  end

  def get_guess(state = %Attempt{guess: _guess}) do
    state
  end

  def set_likeness(%Attempt{tries: 4}, _) do
    {:error, :out_of_tries}
  end

  def set_likeness(state = %Attempt{guess: password, length: length}, likeness) when likeness >= length do
    %{state | password: password}
  end

  def set_likeness(state = %Attempt{tries: tries, guess: guess, words: word_list}, likeness) do
    new_word_list = word_list
    |> Enum.filter(fn w ->
      likeness == calc_likeness(w, guess)
    end)

    case length(new_word_list) do
      0 ->
        {:error, :no_matching_likeness}
      1 ->
        %{state | password: hd(new_word_list)}

      _ ->
        %{state | tries: tries + 1, guess: nil, words: new_word_list}
    end
  end



  ## Private Functions

  defp best_guess(words) do
    {best_guess, _} = words
    |> Enum.map(fn x ->
      {x, calc_score(x, words)}
    end)
    |> Enum.sort(fn {_, a}, {_, b} -> a >= b end)
    |> hd
    best_guess
  end

  defp calc_score(word, words) do
    words
    |> Stream.map(&calc_likeness(&1, word))
    |> Stream.uniq
    |> Enum.count
  end

  defp calc_likeness(a, b) do
    Stream.zip(String.graphemes(a), String.graphemes(b))
    |> Stream.filter(fn {a, b} -> a == b end)
    |> Enum.count
  end

end
