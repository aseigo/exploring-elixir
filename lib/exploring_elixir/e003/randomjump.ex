defmodule ExploringElixir.ChildSpec.RandomJump do
  use GenServer

  def start_link() do
    GenServer.start_link __MODULE__, :rand.jump, name: __MODULE__
  end

  def rand(max) when is_integer(max) do
    GenServer.call __MODULE__, {:rand, max}
  end

  def handle_call({:rand, max}, _from, state) when is_integer(max) do
    {number, state} = :rand.uniform_s(max, state);
    {:reply, number, state}
  end
end
