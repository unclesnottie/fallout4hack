defmodule FalloutHacker.CLI do
  @moduledoc """
  Documentation for FalloutHacker.CLI.
  """

  alias FalloutHacker.Core

  def main(_args) do
    words = IO.gets("Enter possible passwords:  ")
    pid = Core.new()
    case Core.set_words(pid, words) do
      [_ | _] ->
        hack_password(pid)
      {:error, :unequal_length} ->
        IO.puts("Words must all be the same length.")
        main(:ok)
    end
  end

  defp hack_password(pid) do
    case Core.get_guess(pid) do
    {:guess, best_guess} ->
      IO.puts("Your best guess is \"#{best_guess}\".")

      likeness = IO.gets("Enter likeness: ")
      |> to_int()

      case Core.set_likeness(pid, likeness) do
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
