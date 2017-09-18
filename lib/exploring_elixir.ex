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
    ExploringElixir.AutoCluster.autocluster()
  end

  def ecto_perf do
    Application.ensure_all_started :postgrex
    Supervisor.start_child ExploringElixir.Supervisor, EctoBench.Repo.child_spec([])
    Enum.each [10, 100, 1000, 100000], fn x -> EctoBench.simpleWrites x end
  end
end
