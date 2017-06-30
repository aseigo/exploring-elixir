defmodule ExploringElixir.MapBench do
  def match do
    %{dates: dates, atoms: atoms} = init_maps()

    Benchee.run %{
      "Function header matching" =>
        fn ->
          date = match(dates)
          uuid = match(atoms)
          {date, uuid}
        end,
      "Inline matching" =>
        fn ->
          %{today: date} = dates
          %{:to_uniq_entries => a, :comprehension_filter => b, :"Australia/Hobart" => c} = atoms
          {date, a, b, c}
        end
    }, formatters: [&Benchee.Formatters.HTML.output/1],
       formatter_options: [html: [file: "benchmarks/map_match.html"]]

  end

  @table_name :large_table_test
  def ets do
    %{dates: dates, atoms: atoms} = init_maps()
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

  defp init_maps() do
    now = Timex.today
    date_map =
      Enum.reduce(1..(365*2), %{today: now},
                  fn(days, date_map) ->
                    then = Timex.shift(now, days: days)
                    Map.put(date_map,  DateTime.to_string(Timex.to_datetime(then)), then)
                  end)

    atom_map =
      Enum.reduce(:all_atoms.all_atoms, %{},
                  fn(atom, atom_map) ->
                    Map.put(atom_map, atom, UUID.uuid4)
                  end)

    %{
      dates: date_map,
      atoms: atom_map
    }
  end

  def match(%{"2018-07-02 00:00:00Z": date}), do: date
  def match(%{:"MACRO-unquote" => uuid}), do: uuid
  def match(%{imports_from_env: uuid}), do: uuid
  def match(%{ctime:  uuid}), do: uuid
  def match(%{"2017-07-02 00:00:00Z": date}), do: date
  def match(_), do: :not_found
end
