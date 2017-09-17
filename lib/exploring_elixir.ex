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
    spawn(
    fn ->
      loop =
        fn f ->
          ExploringElixir.AutoCluster.visible_nodes()
          receive do
            {:nodeup, node} ->
              IO.puts IO.ANSI.green() <> String.duplicate(<<0x1F603 :: utf8>>, 5) <> IO.ANSI.reset() <> " New node joined: #{inspect node}"
              f.(f)
            {:nodedown, node} ->
              IO.puts IO.ANSI.red() <> String.duplicate(<<0x1F630 :: utf8>>, 5) <> IO.ANSI.reset() <> " Node departed: #{inspect node}"
              f.(f)
            _ ->
              :ok
          end
        end

      Logger.info "Starting node monitor process #{inspect self()}"
      :net_kernel.monitor_nodes true
      loop.(loop)
    end
    )

    ExploringElixir.AutoCluster.autocluster()
  end

  def ecto_perf do
    Application.ensure_all_started :postgrex
    Supervisor.start_child ExploringElixir.Supervisor, EctoBench.Repo.child_spec([])
    Enum.each [10, 100, 1000, 100000], fn x -> EctoBench.simpleWrites x end
  end
end
