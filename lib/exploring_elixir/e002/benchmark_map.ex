defmodule ExploringElixir.Benchmark.Map do
  def match do
    %{dates: dates, atoms: atoms} = init_maps()
    count = 1000

    Benchee.run %{
      "Function header matching" =>
        fn -> function_headers(dates, atoms, count, count) end,
      "Inline matching" =>
        fn -> inline_match(dates, atoms, count, count) end
    }, formatters: [&Benchee.Formatters.HTML.output/1],
       formatter_options: [html: [file: "benchmarks/map_match.html"]]
  end

  def function_headers(_dates, _atoms, garbage, 0) do
    garbage
  end

  def function_headers(dates, atoms, _garbage, count) do
    date = match(dates)
    uuid = match(atoms)
    function_headers(dates, atoms, {date, uuid}, count - 1)
  end

  def match(%{"2018-07-02 00:00:00Z": date}), do: date
  def match(%{:to_uniq_entries => a, :comprehension_filter => b, :"Australia/Hobart" => c}), do: {a, b, c}
  def match(%{:"MACRO-unquote" => uuid}), do: uuid
  def match(%{imports_from_env: uuid}), do: uuid
  def match(%{ctime:  uuid}), do: uuid
  def match(%{"2017-07-02 00:00:00Z": date}), do: date
  def match(_), do: :not_found

  def inline_match(_dates, _atoms, garbage, 0) do
    garbage
  end

  def inline_match(dates, atoms, _garbage, count) do
    %{today: date} = dates
    %{:to_uniq_entries => a, :comprehension_filter => b, :"Australia/Hobart" => c} = atoms
    inline_match(dates, atoms, {date, a, b, c}, count - 1)
  end

  def init_maps() do
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
end
