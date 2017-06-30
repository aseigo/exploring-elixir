defmodule ExploringElixir.OneFive do
  use GenServer

  def child_spec(args) do
    %{id: __MODULE__, start: {__MODULE__, :start_link, [args]}, restart: :permanent, type: :worker}
  end

  def start_link(args) do
    rv = GenServer.start_link __MODULE__, args, name: __MODULE__
    rv
  end

  def ping do
    GenServer.cast __MODULE__, {:ping, self()}
  end

  def handle_cast({:ping, pid}, state) do
    Process.send pid, :pong, []
    {:noreply, state}
  end

  def unicode_atoms do
    IO.puts :こんにちは世界
    IO.puts :Zürich
  end

  def faster_maps do
    ExploringElixir.MapBench.match
  end

  def faster_big_ets_tables do
    ExploringElixir.MapBench.ets
  end
end
