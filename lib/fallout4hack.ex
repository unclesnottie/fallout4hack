defmodule F4Hack do
  @moduledoc """
  Documentation for F4Hack.
  """

  alias F4Hack.Hacker

  def main(_args) do
    likenesses = IO.gets("Enter possible passwords: ")
      |> Hacker.process_input
      |> Hacker.calculate_all_likenesses

    best_guess = Hacker.make_best_guess(likenesses)

    IO.puts "You're best guess is \"#{best_guess}\"."
    likeness = IO.gets("Enter likeness: ")
      |> to_int

    if likeness == String.length(best_guess) do
      IO.puts("The password is \"#{best_guess}\"!")
      exit :normal
    end

    map = Hacker.make_guess(likenesses, best_guess)

    remaining_words = Hacker.get_remaining_words(map, likeness)

    if String.length(best_guess) == String.length(remaining_words) do
      IO.puts("The password is \"#{remaining_words}\"!")
      exit :normal
    end

    IO.puts ["Remaining words: ", remaining_words, "\n"]

    best_guess = Hacker.make_best_guess(map[likeness])

    IO.puts "You're best guess is \"#{best_guess}\"."
    likeness = IO.gets("Enter likeness: ")
      |> to_int

    if likeness == String.length(best_guess) do
      IO.puts("The password is \"#{best_guess}\"!")
      exit :normal
    end

    map = Hacker.make_guess(map[likeness], best_guess)

    remaining_words = Hacker.get_remaining_words(map, likeness)

    if String.length(best_guess) == String.length(remaining_words) do
      IO.puts("The password is \"#{remaining_words}\"!")
      exit :normal
    end

    IO.puts ["Remaining words: ", remaining_words, "\n"]

    best_guess = Hacker.make_best_guess(map[likeness])

    IO.puts "You're best guess is \"#{best_guess}\"."

    if likeness == String.length(best_guess) do
      IO.puts("The password is \"#{best_guess}\"!")
      exit :normal
    end

    map = Hacker.make_guess(map[likeness], best_guess)

    remaining_words = Hacker.get_remaining_words(map, likeness)

    if String.length(best_guess) == String.length(remaining_words) do
      IO.puts("The password is \"#{remaining_words}\"!")
      exit :normal
    end

    IO.puts ["Remaining words: ", remaining_words, "\n"]

    best_guess = Hacker.make_best_guess(map[likeness])

    IO.puts "You're best guess is \"#{best_guess}\"."
    if likeness == String.length(best_guess) do
      IO.puts("The password is \"#{best_guess}\"!")
      exit :normal
    end

    map = Hacker.make_guess(map[likeness], best_guess)

    if String.length(best_guess) == String.length(remaining_words) do
      IO.puts("The password is \"#{remaining_words}\"!")
      exit :normal
    end

    remaining_words = Hacker.get_remaining_words(map, likeness)

    IO.puts ["Remaining words: ", remaining_words, "\n"]

    best_guess = Hacker.make_best_guess(map[likeness])

    IO.puts "You're best guess is \"#{best_guess}\"."
  end

  defp to_int(int) do
    int
      |> String.trim
      |> String.to_integer
  end
end
