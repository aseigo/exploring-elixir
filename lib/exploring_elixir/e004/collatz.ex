defmodule ExploringElixir.Collatz do
  @moduledoc """
  A very simple implementation of code to demonstrate the Collatz
  conjecture over the valid range of integers

  See https://en.wikipedia.org/wiki/Collatz_conjecture
  """

  import Integer

  @spec step_count_for(values :: list|integer) :: list
  def step_count_for([]), do: []

  def step_count_for(values) when is_list(values) do
    values
    |> Enum.sort
    |> Enum.uniq
    |> Enum.map(fn value -> {value, steps value} end)
  end

  def step_count_for(value) when is_integer(value) and value > 0 do
    [{value, steps value}]
  end

  @spec steps(value :: integer, step_count :: integer) :: integer
  defp steps(value, step_count \\ 0) # function head declaration only

  defp steps(1, step_count), do: step_count

  defp steps(value, step_count) when is_even(value) do
    steps(floor_div(value, 2), step_count + 1)
  end

  defp steps(value, step_count) do
    steps(3 * value + 1, step_count + 1)
  end
end
