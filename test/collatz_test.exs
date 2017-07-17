defmodule ExploringElixir.CollatzTest do
  use ExUnit.Case
  use Quixir

  import ExploringElixir.Collatz

  @moduletag :collatz

  test "an empty list results in an empty list" do
    assert [] == step_count_for []
  end

  test "results are returned in sorted order" do
    ptest input: choose(from: [
                                list(of: positive_int(), min: 1),
                                int(min: 1, max: 1000, must_have: [42])
                              ], repeat_for: 10000
    ) do
      results = step_count_for input
      assert is_list(results)

      min_input = [input] |> List.flatten |> Enum.min
      [{first_result, _}|_] = results

      assert min_input == first_result
    end
  end
end
