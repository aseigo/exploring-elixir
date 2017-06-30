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
    }

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
