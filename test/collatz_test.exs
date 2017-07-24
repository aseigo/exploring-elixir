defmodule ExploringElixir.CollatzTest do
  use ExUnit.Case
  use Quixir

  import ExploringElixir.Collatz

  @moduletag :collatz
  require Logger

  test "an empty list results in an empty list" do
    assert [] == step_count_for []
  end

  test "the results are well formed" do
    assert [{1, 0}] = step_count_for 1
    # we assert the results of the Collatz module to be:
    #   -> a list 
    #   -> in order from smallest to largest
    #   -> of 2-tuples
    #   -> which contain the input number and the result
    #   -> the number of steps should be 0 for 1
    #      and greater than 0 for any other positive int
    ptest input: choose(from: [
                          list(of: int(min: 2), min: 1),
                          int(min: 2, must_have: [256, 512]),
                        ], repeat_for: 10_000)
    do
      results = step_count_for input

      assert is_list(results)

      Enum.reduce results, 0,
                  fn {input, _answer}, last_value ->
                    assert last_value < input
                    input
                  end

      Enum.each results, fn {_input, answer} -> assert 0 < answer end
    end
  end
end
