defmodule ExploringElixir do
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
  end

  def episode4 do
  end

  def episode5 do
  end

  def episode6 do
    Application.ensure_all_started :postgrex
    Supervisor.start_child ExploringElixir.Supervisor, ExploringElixir.Repo.Tenants.child_spec([])
    ExploringElixir.Tenants.list
  end

  def episode7 do
    import ExploringElixir.AutoCluster
    output = fn ->
                visible_nodes()
                hidden_nodes()
                all_nodes()
             end

    output.()

    autocluster()
    Process.sleep 500 # give it a chance to cluster

    output.()
  end

  def ecto_perf do
    Application.ensure_all_started :postgrex
    Supervisor.start_child ExploringElixir.Supervisor, EctoBench.Repo.child_spec([])
    Enum.each [10, 100, 1000, 100000], fn x -> EctoBench.simpleWrites x end
  end
end
