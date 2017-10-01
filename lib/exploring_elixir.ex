defmodule ExploringElixir do
  require Logger

  def episode1 do
    # Emulates a hypothetical service (web service, over a TCP socket,
    # another OTP process, etc.) that transforms some JSON for us ...
    # but which suffers from some bugs?
    f = File.read!("data/client.json")
    ExploringElixir.JSONFilter.extract self(), f, "data"
    Toolbelt.flush()
  end

  def episode2 do
    # Features
    ExploringElixir.OneFive.ping
    ExploringElixir.OneFive.unicode_atoms
    ExploringElixir.OneFive.rand_jump

    # Benchmarks
    ExploringElixir.Benchmark.Map.match
    ExploringElixir.Benchmark.Ets.creation
    ExploringElixir.Benchmark.Ets.population
  end

  def episode3 do
    IO.puts "Using child_spec/1, we launched various processes in ExploringElixir.ChildSpec"
    IO.puts "Look in lib/exploring_elixir/application.ex to see how clean it is!"
    IO.puts "Now lets call into them to show they are indeed running:"
    IO.inspect ExploringElixir.ChildSpec.ping ExploringElixir.ChildSpec.Permanent
    IO.inspect ExploringElixir.ChildSpec.ping ExploringElixir.ChildSpec.Temporary
    ExploringElixir.ChildSpec.RandomJump.rand 100
  end

  def episode4 do
    IO.puts "Run the property tests with `mix test --only collatz`"
    IO.puts "NOTE: this will recompile the project in test mode!"

    count = 10
    IO.puts "Run with the first #{count} positive integers:"
    ExploringElixir.Collatz.step_count_for Enum.to_list 1..count
  end

  def episode5 do
  end

  def episode6 do
    Application.ensure_all_started :postgrex
    Supervisor.start_child ExploringElixir.Supervisor, ExploringElixir.Repo.Tenants.child_spec([])
    ExploringElixir.Tenants.list
  end

  def episode7 do
    ExploringElixir.AutoCluster.start()
  end

  def episode8 do
    import OK, only: ["~>>": 2]
    alias ExploringElixir.Time, as: T

    Application.ensure_all_started :timex
    Application.ensure_all_started :postgrex
    Supervisor.start_child ExploringElixir.Supervisor, ExploringElixir.Repo.Tenants.child_spec([])

    IO.puts "== Timestamps .. so many =="
    IO.puts "This computer believes the timestamp to be #{T.Local.os_timestamp}, but this may drift around on us"
    IO.puts "This BEAM vm believes the timestamp to be #{T.Local.os_timestamp}, but this may also drift around on us as well as in relation to the OS time"
    IO.puts "Here is a monotonic (always increasing) time: #{T.Local.monotonic_time}"
    IO.puts "The monotonic time is offset from the \"real\" time by #{T.Local.monotonic_time_offset}"
    IO.puts "So the actual time is something like: #{T.Local.adjusted_monotonic_time}"
    IO.puts ""
    IO.puts "== Zoneless Times and Dates, aka Naive =="
    IO.puts "A point in time: #{T.Local.current_time}"
    IO.puts "A point in the calendar: #{T.Local.current_date}"
    IO.puts "Moving a point in the calendar into the past by one day: #{T.Local.yesterday}"
    IO.puts "If we are sceptical, here's the difference: #{T.Local.just_a_day_away} day"
    IO.puts ""

    IO.puts "== Calendars =="
    IO.puts "In the standard ISO (Gregorian) calendar, today is: #{T.Calendars.today_iso}"
    IO.puts "In the Jalaali calendar, today is: #{T.Calendars.today_jalaali}"
    IO.puts "Converting from Gregorian to Jalaali is easy: #{T.Calendars.convert_to_jalaali ~D[1975-06-18]}"

    IO.puts "The next week of Gregorian days are: "
    T.for_next_week fn date -> date
                               |> Timex.format("%A", :strftime)
                               ~>> (fn x -> "    " <> x end).()
                               |> IO.puts
                    end

    IO.puts "The next week of Jalaali days are: "
    T.for_next_week fn date -> date
                               |> T.Calendars.convert_to_jalaali
                               |> Timex.format("%A", :strftime)
                               ~>> (fn x -> "    " <> x end).()
                               |> IO.puts
                    end


    dates = [
             {Timex.add(DateTime.utc_now, Timex.Duration.from_days(-1)), "yesterday"},
             {DateTime.utc_now, "today"},
             {Timex.now("America/Vancouver"), "Vancouver"},
             {Timex.add(DateTime.utc_now, Timex.Duration.from_days(1)), "tomorrow"}
    ]

    IO.puts ""
    IO.puts "== With Ecto =="
    IO.puts "Filing the database with some data..."
    Enum.each dates, fn {date, data} -> IO.puts "Inserting -> #{data}"; T.Stored.put date, data end

    DateTime.utc_now
    |> ExploringElixir.Time.Stored.get
    |> (fn x -> IO.puts "Today's data: #{inspect x}" end).()
  end

  def ecto_perf do
    Application.ensure_all_started :postgrex
    Supervisor.start_child ExploringElixir.Supervisor, EctoBench.Repo.child_spec([])
    Enum.each [10, 100, 1000, 100000], fn x -> EctoBench.simpleWrites x end
  end
end
