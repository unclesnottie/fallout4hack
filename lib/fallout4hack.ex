defmodule F4Hack do
  @moduledoc """
  Documentation for F4Hack.
  """

  alias F4Hack.Hacker

def main(_args) do
  words = IO.gets("Enter possible passwords:  ")
  pid = Hacker.new()
  case Hacker.set_words(pid, words) do
    [_ | _] ->
      hack_password(pid)
    {:error, :unequal_length} ->
      IO.puts("Words must all be the same length.")
      main(:ok)
  end
end

defp hack_password(pid) do
  case Hacker.get_guess(pid) do
  {:guess, best_guess} ->
    IO.puts("Your best guess is \"#{best_guess}\".")

    likeness = IO.gets("Enter likeness: ")
    |> to_int()

    case Hacker.set_likeness(pid, likeness) do
      {:error, :out_of_tries} ->
        IO.puts("You ran out of tries.")

      {:password, password} ->
        IO.puts("The password is \"#{password}\".")

      remaining_words = [_ | _] ->
        IO.puts("The remaining words are \"#{Enum.join(remaining_words, " ")}\".")
        hack_password(pid)
    end

    {:password, password} ->
      IO.puts("The password is \"#{password}\".")
  end
end

  defp to_int(int) do
    int
      |> String.trim
      |> String.to_integer
  end
end
