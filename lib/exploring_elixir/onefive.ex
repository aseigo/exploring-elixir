defmodule ExploringElixir.OneFive do
  use GenServer

  def child_spec(args) do
    %{id: __MODULE__, start: {__MODULE__, :start_link, [args]}, restart: :permanent, type: :worker}
  end

  def start_link(args) do
    GenServer.start_link __MODULE__, args, name: __MODULE__
  end

  def ping do
    GenServer.cast __MODULE__, {:ping, self()}
  end

  @impl true
  def handle_cast({:ping, pid}, state) do
    Process.send pid, :pong, []
    {:noreply, state}
  end

  def unicode_atoms do
    IO.puts :こんにちは世界
    IO.puts :Zürich
  end

  def rand_jump do
    Enum.each(1..5, fn _ -> IO.puts :rand.uniform(100_000) end)

    IO.puts ".. and now with jump!"
    state = :rand.jump()
    Enum.reduce(1..5, state, fn _, state -> {number, state} = :rand.uniform_s(100_000, state); IO.puts(number); state end)
    
    IO.puts ".. and now in a flow!"
    iterations = 5000
    concurrency = 50
    Flow.from_enumerable(1..iterations)
    |> Flow.partition(stages: concurrency)
    |> Flow.reduce(fn -> :rand.jump() end, fn _input, state -> {number, state} = :rand.uniform_s(100_000, state); IO.puts("#{inspect self()}: #{number}"); state end)
    |> Flow.run
  end

  def faster_maps do
    ExploringElixir.MapBench.match
  end

  def faster_big_ets_tables do
    ExploringElixir.MapBench.ets
  end
end
