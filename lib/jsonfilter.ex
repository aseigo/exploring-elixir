defmodule ExploringElixir.JSONFilter do
  def extract(pid, json, key) when is_pid(pid) and is_binary(json) and is_binary(key) do
    {_worker_pid, _monitor_ref} = spawn_monitor(__MODULE__, :extract_data, [self(), json, key])
    wait_for_response pid
  end

  def wait_for_response(pid) do
    receive do
      {:DOWN, _monitor, _func, _pid, :normal} -> Process.send pid, "Processing successful!", []
      {:DOWN, _monitor, _func, _pid, reason} -> Process.send pid, {:error, "Processing failed: #{inspect reason}"}, []
      data ->
        Process.send pid, data, []
        wait_for_response pid
    after
      1_000 -> Process.send pid, {:error, "Timeout"}, []
    end
  end

  def extract_data(pid, json, key) when is_pid(pid) and is_binary(json) and is_binary(key) do
    {:ok, term} = Poison.decode json
    Process.send pid, {:progress, 50}, []
    Process.send pid, term[key], []
    Process.send pid, {:progress, 100}, []
  end
end
