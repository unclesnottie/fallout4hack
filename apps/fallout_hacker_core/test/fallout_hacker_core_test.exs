defmodule FalloutHacker.CoreTest do
  use ExUnit.Case, async: true
  doctest FalloutHacker.Core

  alias FalloutHacker.Core

  setup do
    pid = Core.new()
    %{pid: pid}
  end

  describe "Hacker.start_link/0" do
    test "starts a new process", %{pid: pid} do
      assert Process.alive?(pid)
    end
  end

  describe "Hacker.set_words/2" do
    test "returns error when words have unequal length", %{pid: pid} do
      assert Core.set_words(pid, "hello hi") == {:error, :unequal_length}
    end

    test "returns remaining words when words have equal length", %{pid: pid} do
      assert Core.set_words(pid, "hello howdy") == ["HELLO", "HOWDY"]
    end
  end

  describe "Hacker.get_guess/1" do
    test "returns password when only one possible word", %{pid: pid} do
      Core.set_words(pid, "hello")
      assert Core.get_guess(pid) == {:password, "HELLO"}
    end
  end
end
