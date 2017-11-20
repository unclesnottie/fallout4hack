defmodule F4Hack do
  @moduledoc """
  Documentation for F4Hack.
  """

#  alias F4Hack.Hacker
  alias F4Hack.HackerV2, as: Hacker

def main(_args) do
  words = IO.gets("Enter possible passwords:  ")
  {:ok, pid} = Hacker.start_link()
  case Hacker.set_words(pid, words) do
    :ok ->
      hack_password(pid)
    {:error, msg} ->
      IO.puts(msg)
      main(:ok)
  end
end

defp hack_password(pid) do
  {:guess, best_guess} = Hacker.get_guess(pid)
  IO.puts("Your best guess is \"#{best_guess}\".")

  likeness = IO.gets("Enter likeness: ")
  |> to_int()

  case Hacker.set_likeness(pid, likeness) do
    {:password, password} ->
      IO.puts("The password is \"#{password}\".")

    {:remaining_words, remaining_words} ->
      IO.puts("The remaining words are \"#{remaining_words}\".")
      hack_password(pid)
  end
end

  defp to_int(int) do
    int
      |> String.trim
      |> String.to_integer
  end
end
