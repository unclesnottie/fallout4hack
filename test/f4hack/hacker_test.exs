defmodule F4Hack.HackerTest do
  use ExUnit.Case
  doctest F4Hack.Hacker

  alias F4Hack.Hacker

  describe "Hacker.process_input/1" do
    test "splits into list of lists" do
      expected = ["HELLO", "FOOLS", "BOOKS"]
      actual = "HELLO FOOLS BOOKS"
        |> Hacker.process_input
      assert expected == actual
    end

    test "uppercases each letter" do
      actual ="hello FOOLS bOOkS"
        |> Hacker.process_input
        |> Enum.join
      expected = String.upcase(actual)
      assert expected == actual
    end
  end

  describe "Hacker.calculate_likenesses/2" do
    test "removes the word itself" do
      words = [["B","O","O","K","S"]]
      word = ["B","O","O","K","S"]
      expected = {"BOOKS", %{}}
      actual = Hacker.calculate_likenesses(word, words)
      assert expected == actual
    end

    test "calculates correctly when same letters are in different places" do
      words = [["P","O","R","T","S"]]
      word = ["S","P","O","R","T"]
      expected = {"SPORT", %{ 0 => [{"PORTS", %{}}] }}
      actual = Hacker.calculate_likenesses(word, words)
      assert expected == actual
    end

    test "calculates likeness correctly, no two words have same likeness" do
      words = [["B","O","O","K","S"], ["F","O","O","L","S"], ["E","M","A","I","L"], ["S","T","O","C","K"]]
      word = ["B","O","O","K","S"]
      expected = {"BOOKS", %{ 0 => [{"EMAIL", %{}}], 1 => [{"STOCK", %{}}], 3 => [{"FOOLS", %{}}] }}
      actual = Hacker.calculate_likenesses(word, words)
      assert expected == actual
    end

    test "calculates likeness correctly, two words have same likeness" do
      words = [["B","O","O","K","S"], ["F","O","O","L","S"], ["P","O","O","L","S"], ["B","O","X","E","S"]]
      word = ["B","O","O","K","S"]
      expected = {"BOOKS", %{
        3 => [
          {"FOOLS", %{
            2 => [{"BOXES", %{}}],
            4 => [{"POOLS", %{}}]
          }},
          {"POOLS", %{
            2 => [{"BOXES", %{}}],
            4 => [{"FOOLS", %{}}]
          }},
          {"BOXES", %{
            2 => [{"FOOLS", %{
              4 => [{"POOLS", %{}}]
            }}, {"POOLS", %{
              4 => [{"FOOLS", %{}}]
            }}]
          }}
        ]
      }}
      actual = Hacker.calculate_likenesses(word, words)
      assert expected == actual
    end
  end

  describe "Hacker.calculate_likeness/2" do
    test "returns zero when no letters match" do
      assert 0 == Hacker.calculate_likeness(["M","A","I","N"], ["O","B","O","E"])
    end

    test "returns zero when letters match but are out of order" do
      assert 0 == Hacker.calculate_likeness(["P","O","R","T","S"], ["S","P","O","R","T"])
    end

    test "returns 1 when a letter matches" do
      assert 1 == Hacker.calculate_likeness(["B","A","R","N"], ["B","O","O","K"])
    end

    test "returns correct count when more than one letters match" do
      assert 3 == Hacker.calculate_likeness(["B","O","O","K","S"], ["F","O","O","L","S"])
    end
  end

  describe "Hacker.max_depth/1" do
    test "returns one when map is empty" do
      likenesses = {"BOOKS", %{}}
      assert 1 == Hacker.max_depth(likenesses)
    end

    test "returns two when there are two words with likeness of zero" do
      likenesses = {"SPORT", %{ 0 => [{"PORTS", %{}}] }}
      assert 2 == Hacker.max_depth(likenesses)
    end

    test "returns correct depth when depth is greater than two" do
      likenesses = {"SPORT", %{ 0 => [{"PORTS", %{ 0 => [{"ALIVE", %{}}]}}, {"ALIVE", %{ 0 => [{"PORTS", %{}}]}}] }}
      assert 3 == Hacker.max_depth(likenesses)
    end

    test "returns correct depth when multiple paths" do
      likenesses = {"BOOKS", %{
        3 => [
          {"FOOLS", %{
            2 => [{"BOXES", %{}}],
            4 => [{"POOLS", %{}}]
          }},
          {"POOLS", %{
            2 => [{"BOXES", %{}}],
            4 => [{"FOOLS", %{}}]
          }},
          {"BOXES", %{
            2 => [{"FOOLS", %{
              4 => [{"POOLS", %{}}]
            }}, {"POOLS", %{
              4 => [{"FOOLS", %{}}]
            }}]
          }}
        ]
      }}
      assert 4 == Hacker.max_depth(likenesses)
    end
  end

end
