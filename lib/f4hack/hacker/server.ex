defmodule F4Hack.Hacker.Server do
  @moduledoc """
  Documentation for F4Hack.Hacker.Server.
  """

  use GenServer
  alias F4Hack.Hacker.Impl

  def init(:ok) do
    {:ok, Impl.initialize_state()}
  end

  def handle_call({:words, words}, _from, state) do
    case Impl.initialize_word_list(words) do
      {:ok, new_state} ->
        reply_remaining_words(new_state)

      {:error, reason} ->
        reply_error(state, reason)
    end
  end

  def handle_call(:guess, _from, state) do
    case Impl.get_guess(state) do
      new_state = %{password: nil} ->
        reply_guess(new_state)

      new_state ->
        reply_password(new_state)
    end
  end

  def handle_call({:likeness, likeness}, _from, state) do
    case Impl.set_likeness(state, likeness) do
      {:error, reason} ->
        reply_error(state, reason)

      new_state = %{password: nil} ->
        reply_remaining_words(new_state)

      new_state ->
        reply_password(new_state)
    end
  end

  ## Private Functions

  defp reply_password(state = %{password: password}) do
    {:stop, :normal, {:password, password}, state}
  end

  defp reply_error(state, reason) do
    {:stop, :normal, {:error, reason}, state}
  end

  defp reply_remaining_words(state = %{words: remaining_words}) do
    {:reply, remaining_words, state}
  end

  defp reply_guess(state = %{guess: guess}) do
    {:reply, {:guess, guess}, state}
  end

end
