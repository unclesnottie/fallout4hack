defmodule F4Hack.Hacker.ImplTest do
  use ExUnit.Case, async: true
  doctest F4Hack.Hacker.Impl

  alias F4Hack.Hacker.Impl
  alias F4Hack.Hacker.Attempt

  describe "Impl.initialize_word_list/1" do
    test "returns error when words have unequal length" do
      assert Impl.initialize_word_list("hello hi") == {:error, :unequal_length}
    end

    test "returns remaining words when words have equal length" do
      expected = {:ok, %Attempt{tries: 0, guess: nil, password: nil, words: ["HELLO", "HOWDY"], length: 5}}
      assert Impl.initialize_word_list("hello howdy") == expected
    end
  end

  describe "Impl.get_guess/1" do
    test "returns password when only one possible word" do
      {:ok, state} = Impl.initialize_word_list("hello")
      assert Impl.get_guess(state) == %{state | guess: "HELLO", password: "HELLO"}
    end

    test "makes and returns best guess when all guesses are equal" do
      {:ok, state} = Impl.initialize_word_list("hello howdy hxxxx")
      assert Impl.get_guess(state) == %{state | guess: "HELLO", words: ["HOWDY", "HXXXX"]}
    end

    test "makes and returns best guess when one guess is better" do
      {:ok, state} = Impl.initialize_word_list("cello howdy hello giver")
      assert Impl.get_guess(state) == %{state | guess: "HELLO", words: ["CELLO", "HOWDY", "GIVER"]}
    end

    test "returns best guess if guess was already calculated" do
      {:ok, state} = Impl.initialize_word_list("hello howdy")
      state = %{state | guess: "HELLO"}
      assert Impl.get_guess(state) == state
    end
  end

  describe "Impl.set_likeness/2" do
    test "returns error when out of tries" do
      {:ok, state} = Impl.initialize_word_list("hello howdy")
      state = Impl.get_guess(state)
      state = %{state | tries: 4}
      assert Impl.set_likeness(state, 0) == {:error, :out_of_tries}
    end

    test "returns password when likeness equals word length" do
      {:ok, state} = Impl.initialize_word_list("hello howdy")
      state = Impl.get_guess(state)
      assert Impl.set_likeness(state, 5) == %{state | password: "HELLO"}
    end

    test "returns password when likeness is greater than word length" do
      {:ok, state} = Impl.initialize_word_list("hello howdy")
      state = Impl.get_guess(state)
      assert Impl.set_likeness(state, 6) == %{state | password: "HELLO"}
    end

    test "returns password when only one word left" do
      {:ok, state} = Impl.initialize_word_list("hello howdy")
      state = Impl.get_guess(state)
      assert Impl.set_likeness(state, 1) == %{state | password: "HOWDY"}
    end

    test "updates word list, guess and tries when multiple words remain" do
      {:ok, state} = Impl.initialize_word_list("hello howdy haunt")
      state = Impl.get_guess(state)
      assert Impl.set_likeness(state, 1) == %{state | words: ["HOWDY", "HAUNT"], guess: nil, tries: 1}
    end
  end

end
