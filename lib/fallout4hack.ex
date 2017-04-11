defmodule F4Hack do
  @moduledoc """
  Documentation for F4Hack.
  """

  alias F4Hack.Hacker

  def main(_args) do
    words = IO.gets("Enter possible passwords:\n")
      |> Hacker.process_input

    likenesses = words
      |> Enum.map(&Hacker.calculate_likenesses(&1, words))

    likenesses
      |> IO.inspect
  end
end
