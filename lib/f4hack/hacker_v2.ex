defmodule F4Hack.HackerV2 do
  @moduledoc """
  Documentation for F4Hack.HackerV2.
  """
  use GenServer

  ## Client API

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def set_words(pid, words) do
    GenServer.call(pid, {:words, words})
  end

  def get_guess(pid) do
    GenServer.call(pid, :guess)
  end

  def set_likeness(pid, likeness) do
    GenServer.call(pid, {:likeness, likeness})
  end

  ## Callbacks

  def init(:ok) do
    {:ok, %{tries: 0, guess: nil, words: [], length: 0}}
  end

  def handle_call({:words, words}, _from, state) do
    word_list = words
    |> String.upcase
    |> String.split

    word_length = word_list
    |> hd
    |> String.length

    if Enum.all?(word_list, fn(w) -> String.length(w) == word_length end) do
      {:reply, :ok, %{tries: 0, guess: nil, words: word_list, length: word_length}}
    else
      {:stop, :normal, {:error, "Words must be same length"}, state}
    end
  end

  def handle_call(:guess, _from, state = %{tries: 4}) do
    {:stop, :normal, :out_of_tries, state}
  end

  def handle_call(:guess, _from, state = %{words: [password]}) do
    reply_password(password, state)
  end

  def handle_call(:guess, _from, state = %{guess: nil, words: word_list}) do
    best_guess = best_guess(word_list)
    new_word_list = word_list -- [best_guess]
    {:reply, {:guess, best_guess}, %{state | guess: best_guess, words: new_word_list}}
  end

  def handle_call(:guess, _from, state = %{guess: guess}) do
    {:reply, {:guess, guess}, state}
  end

  def handle_call({:likeness, likeness}, _from, state = %{guess: password, length: length}) when likeness >= length do
    reply_password(password, state)
  end

  def handle_call({:likeness, likeness}, _from, state = %{tries: tries, guess: guess, words: word_list}) do
    new_word_list = word_list
    |> Enum.filter(fn w ->
      likeness == calc_likeness(w, guess)
    end)

    case length(new_word_list) do
      1 -> reply_password(hd(new_word_list), state)
      _ -> {:reply, {:remaining_words, Enum.join(new_word_list, " ")}, %{state | tries: tries + 1, guess: nil, words: new_word_list}}
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

  defp reply_password(password, state) do
    {:stop, :normal, {:password, password}, %{state | guess: password}}
  end

end
