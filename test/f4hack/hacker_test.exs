defmodule F4Hack.HackerTest do
  use ExUnit.Case
  doctest F4Hack.Hacker

  alias F4Hack.Hacker

  test "process_input splits into list of lists" do
    expected = [["H","E","L","L","O"], ["F","O","O","L","S"], ["B","O","O","K","S"]]
    actual = "HELLO FOOLS BOOKS"
      |> Hacker.process_input
    assert actual == expected
  end

  test "process_input uppercases each letter" do
    actual ="hello FOOLS bOOkS"
      |> Hacker.process_input
      |> List.flatten
      |> Enum.join
    expected = String.upcase(actual)
    assert actual == expected
  end

  test "calculate_likenesses removes the word itself" do
    words = [["B","O","O","K","S"]]
    word = ["B","O","O","K","S"]
    expected = {"BOOKS", []}
    actual = Hacker.calculate_likenesses(word, words)
    assert actual == expected
  end

  test "calculate_likenesses calculates correctly when same letters are in different places" do
    words = [["P","O","R","T","S"]]
    word = ["S","P","O","R","T"]
    expected = {"SPORT", [{"PORTS", 0}]}
    actual = Hacker.calculate_likenesses(word, words)
    assert actual == expected
  end

  test "calculate_likenesses calculates likeness correctly" do
    words = [["B","O","O","K","S"], ["F","O","O","L","S"], ["E","M","A","I","L"], ["S","T","O","C","K"]]
    word = ["B","O","O","K","S"]
    expected = {"BOOKS", [{"FOOLS", 3}, {"EMAIL", 0}, {"STOCK", 1}]}
    actual = Hacker.calculate_likenesses(word, words)
    assert actual == expected
  end

  test "calculate_likeness returns zero when no letters match" do
    assert Hacker.calculate_likeness(["M","A","I","N"], ["O","B","O","E"]) == 0
  end

  test "calculate_likeness returns zero when letters match but are out of order" do
    assert Hacker.calculate_likeness(["P","O","R","T","S"], ["S","P","O","R","T"]) == 0
  end

  test "calculate_likeness returns 1 when a letter matches" do
    assert Hacker.calculate_likeness(["B","A","R","N"], ["B","O","O","K"]) == 1
  end

  test "calculate_likeness returns correct count when more than one letters match" do
    assert Hacker.calculate_likeness(["B","O","O","K","S"], ["F","O","O","L","S"]) == 3
  end

end
