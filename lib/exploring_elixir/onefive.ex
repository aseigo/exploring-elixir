defmodule ExploringElixir.OneFive do
  def unicode_atoms do
    IO.puts :こんにちは世界
    IO.puts :Zürich
  end

  def faster_maps do
    ExploringElixir.MapBench.match
  end

  def faster_big_ets_tables do
    ExploringElixir.MapBench.ets
  end
end
