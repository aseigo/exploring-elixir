defmodule ExploringElixir.ChildSpec do
  use GenServer

  def child_spec(%{type: :random}) do
    %{id: ExploringElixir.ChildSpec.RandomJump,
      start: {ExploringElixir.ChildSpec.RandomJump, :start_link, []},
      restart: :permanent, type: :worker}
  end

  def child_spec(%{type: :forever}) do
    name = Module.concat(__MODULE__, :Permanent)
    %{id: name, start: {__MODULE__, :start_link, [name]}, restart: :permanent, type: :worker}
  end

  def child_spec(_args) do
    name = Module.concat(__MODULE__, :Temporary)
    %{id: name, start: {__MODULE__, :start_link, [name]}, restart: :temporary, type: :worker}
  end

  def start_link(name) do
    GenServer.start_link __MODULE__, [], name: name
  end

  def ping name do
    GenServer.cast name, {:ping, self()}
  end

  @impl true
  def handle_cast({:ping, pid}, state) do
    Process.send pid, :pong, []
    {:noreply, state}
  end
end
