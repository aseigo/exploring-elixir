defmodule BackPressurePort do
  use GenServer

  require Logger

  def start_link(path, rate_limit \\ 100)

  def start_link(path, rate_limit) when is_binary(path), do: start_link(String.to_charlist(path), rate_limit)

  def start_link(path, rate_limit)
      when is_list(path) and is_integer(rate_limit) and rate_limit > 0
  do
    {:ok, pid} = GenServer.start_link __MODULE__, [path, rate_limit]
    GenServer.call pid, :open_port
    {:ok, pid}
  end

  def init([path, rate_limit]) do
    {:ok, %{port: nil, path: path, limit: rate_limit}}
  end

  def set_rate_limit(pid, limit) when is_integer(limit) do
    GenServer.cast pid, {:limit, limit}
  end

  def handle_cast({:limit, limit}, state) do
    {:noreply, %{state|limit: limit}}
  end

  def handle_call(:open_port, _from, %{port: nil} = state) do
    p = open state
    {:reply, :ok, %{state|port: p}}
  end

  def handle_info({_port, {:data, {:eol, data}}}, state) do
    IO.inspect data
    {:noreply, rate_limit(state)}
  end

  defp rate_limit(%{port: nil, limit: limit} = state) do
    case queue_length() do
      length when length < limit * 3 / 2 ->
        Logger.debug "#{inspect self()} Resuming..."
        p = open state
        %{state|port: p}
      _ -> state
    end
  end

  defp rate_limit(%{port: p, limit: limit} = state) do
    case queue_length() do
      length when length >= limit ->
        Logger.debug "#{inspect self()} Pausing..."
        Port.close p
        %{state|port: nil}
      _ ->
        state
    end
  end

  defp queue_length do
    {:message_queue_len, queue_length} = :erlang.process_info(self(), :message_queue_len)
    queue_length
  end

  defp open(%{path: path}) do
    Port.open path, [{:line, 4096}, :eof]
  end
end
