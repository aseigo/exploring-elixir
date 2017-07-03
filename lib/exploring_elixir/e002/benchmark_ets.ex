defmodule ExploringElixir.Benchmark.Ets do
  def creation do
    Benchee.run %{
      "Create and destroy 10_000 ets tables" =>
        fn ->
          Enum.each(1..10_000, fn count -> :ets.new(String.to_atom(Integer.to_string(count)), [:named_table]) end)
          Enum.each(1..10_000, fn count -> :ets.delete(String.to_atom(Integer.to_string(count))) end)
        end,
      "Create and destroy 10_000 ets tables in parallel" =>
        fn ->
          Flow.from_enumerable(1..10_000)
          |> Flow.each(fn number -> :ets.new(String.to_atom(Integer.to_string(number)), [:named_table, :public]) end)
          |> Flow.run
        end,
      }, formatters: [&Benchee.Formatters.HTML.output/1],
         formatter_options: [html: [file: "benchmarks/ets_creation.html"]]
  end

  @table_name :large_table_test
  def population do
    %{dates: dates, atoms: atoms} = ExploringElixir.Benchmark.Map.init_maps()
    sizes = %{
              "Few rows, large data" => {100, dates, atoms},
              "Few rows, small data" => {100, self(), self()},
              "Medium row count, small data" => {10_000, self(), self()},
              "Medium row count, larger data" => {10_000, dates, self()},
              "Large row count, small data" => {100_000, self(), self()}
            }

    Benchee.run %{
      "Inserting rows" =>
        fn {rows, data_set_a, data_set_b} ->
          :ets.new(@table_name, [:named_table, :public])
          fill_ets_table(rows, data_set_a, data_set_b)
          :ets.delete(@table_name)
        end,
      "Lookup up random rows, including some misses" =>
        fn {rows, data_set_a, data_set_b} ->
          :ets.new(@table_name, [:named_table, :public])
          fill_ets_table(rows, data_set_a, data_set_b)
          rand_range = round(rows * 1.2)
          Enum.each(1..rows,
                    fn _x -> :ets.lookup(@table_name, :rand.uniform(rand_range)) end)
          :ets.delete(@table_name)
        end
    }, inputs: sizes,
       formatters: [&Benchee.Formatters.HTML.output/1],
       formatter_options: [html: [file: "benchmarks/ets_tables.html"]]
  end

  defp fill_ets_table(rows, data_set_a, data_set_b) do
    half = Integer.floor_div(rows, 2)
    Enum.each(1..half,
              fn x -> :ets.insert(@table_name, {x, data_set_a}) end)
    Enum.each((half + 1)..rows,
              fn x -> :ets.insert(@table_name, {x, data_set_b}) end)
  end
end
