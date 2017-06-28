defmodule ExploringElixirTest do
  use ExUnit.Case
  doctest ExploringElixir

  test "episode 1" do
    assert ExploringElixir.episode1() == :ok
  end
end
