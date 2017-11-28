defmodule FalloutHacker.Core.Attempt do
  @moduledoc """
  Documentation for FalloutHacker.Core.Attempt.
  """

  defstruct tries: 0, guess: nil, password: nil, words: [], length: 0
end
