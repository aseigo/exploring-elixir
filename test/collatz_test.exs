defmodule ExploringElixir.CollatzTest do
  use ExUnit.Case
  use Quixir

  import ExploringElixir.Collatz

  @moduletag :collatz

  test "an empty list results in an empty list" do
    assert [] == step_count_for []
  end

  test "results are returned in sorted order" do
    # we assert the results of the Collatz module to be:
    #   -> a list 
    #   -> in order from smallest to largest
    #   -> of 2-tuples
    #   -> which contain the input number and the result
    #   -> which should always be one
    # the following Quixir property test exists to confirm
    # the validity of that model
    ptest input: choose(from: [
                                list(of: positive_int(), min: 1),
                                int(min: 1, max: 1000, must_have: [42])
                              ], repeat_for: 10000
    ) do
      # get our results
      results = step_count_for input

      # make sure we are getting a list as we expect
      assert is_list(results)

      # ensure that the first item in the list is the smallest value processed
      Enum.reduce results, 0, fn {input, _answer}, last_value -> assert last_value <= input; input end

      # ensure that all inputs resulted in a result of 1
      Enum.each results, fn {_number, answer} -> assert 1 == answer end
    end
  end
end
