defmodule EctoBench do
  def simpleWrites(batch_size) do
    inputs = %{
               "Single" => 1,
               "Concurrency 2" => 2,
               "Concurrency 16" => 16,
               "Concurrency 32" => 32,
               "Concurrency 64" => 64
             }
    Benchee.run %{
      "Simple single-table writes" => fn(concurrency) -> EctoBench.simpleWrites(concurrency, batch_size) end
    }, inputs: inputs
  end

  def simpleWrites(1, iterations) do
    changeset = table1SimpleInsert()
    Enum.each(1..iterations,
              fn _ -> EctoBench.Repo.insert(changeset) end)
  end

  def simpleWrites(concurrency, iterations) do
    changeset = table1SimpleInsert()
    Flow.from_enumerable(1..iterations)
    |> Flow.partition(stages: concurrency)
    |> Flow.each(fn _ -> EctoBench.Repo.insert(changeset) end)
    |> Flow.run
  end

  def simpleWritesHandRolled(concurrency, iterations) do
    changeset = table1SimpleInsert()
    jobs = Integer.floor_div(iterations, concurrency)
    #rem = iterations - (jobs * concurrency)
    spawn_workers(changeset, jobs, iterations)
    wait_on_workers(concurrency)
  end

  defp wait_on_workers(0) do
    :ok
  end

  defp wait_on_workers(concurrency) do
    receive do
      :worker_done -> wait_on_workers(concurrency - 1)
    end
  end

  defp spawn_workers(_changeset, _segment_size, iterations) when iterations <= 0 do
    :ok
  end

  defp spawn_workers(changeset, segment_size, iterations) do
    pid = self()
    spawn(fn -> worker(changeset, pid, segment_size) end)
    spawn_workers(changeset, segment_size, iterations - segment_size)
  end

  defp worker(_changeset, pid, count) when count <= 0 do
    Process.send pid, :worker_done, []
  end

  defp worker(changeset, pid, count) do
    EctoBench.Repo.insert(changeset)
    worker(changeset, pid, count - 1)
  end

  defp table1SimpleInsert do
    EctoBench.Table1.changeset(%EctoBench.Table1{}, %{truth: true})
  end
end
