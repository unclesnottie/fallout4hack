defmodule FalloutHacker.Core.Server do
  @moduledoc """
  Documentation for FalloutHacker.Core.Server.
  """

  use GenServer
  alias FalloutHacker.Core.Impl
  alias FalloutHacker.Core.Attempt

  def init(:ok) do
    {:ok, %Attempt{}}
  end

  def handle_call({:words, words}, _from, state = %Attempt{}) do
    case Impl.initialize_word_list(words) do
      {:ok, new_state} ->
        reply_remaining_words(new_state)

      {:error, reason} ->
        exit_error(state, reason)
    end
  end

  def handle_call(:guess, _from, state = %Attempt{}) do
    case Impl.get_guess(state) do
      new_state = %{password: nil} ->
        reply_guess(new_state)

      new_state ->
        reply_password(new_state)
    end
  end

  def handle_call({:likeness, likeness}, _from, state = %Attempt{}) do
    case Impl.set_likeness(state, likeness) do
      {:error, :no_matching_likeness} ->
        reply_error(state, :no_matching_likeness)

      {:error, reason} ->
        exit_error(state, reason)

      new_state = %{password: nil} ->
        reply_remaining_words(new_state)

      new_state ->
        reply_password(new_state)
    end
  end

  ## Private Functions

  defp reply_password(state = %Attempt{password: password}) do
    {:stop, :normal, {:password, password}, state}
  end

  defp reply_error(state, reason) do
    {:reply, {:error, reason}, state}
  end

  defp exit_error(state, reason) do
    {:stop, :normal, {:error, reason}, state}
  end

  defp reply_remaining_words(state = %Attempt{words: remaining_words}) do
    {:reply, remaining_words, state}
  end

  defp reply_guess(state = %Attempt{guess: guess}) do
    {:reply, {:guess, guess}, state}
  end
end
