defmodule FalloutHacker.Core do
  @moduledoc """
  Documentation for FalloutHacker.Core.
  """

  ## Client API

  def new() do
    {:ok, pid} = GenServer.start_link(FalloutHacker.Core.Server, :ok, [])
    pid
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

end
