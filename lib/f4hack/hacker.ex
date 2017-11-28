defmodule F4Hack.Hacker do
  @moduledoc """
  Documentation for F4Hack.Hacker.
  """
  alias F4Hack.Hacker.Server

  ## Client API

  def new() do
    {:ok, pid} = GenServer.start_link(F4Hack.Hacker.Server, :ok, [])
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
