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
end
