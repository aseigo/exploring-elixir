defmodule ExploringElixir.AutoCluster do
  def visible_nodes, do: Node.list() |> display_nodes("Visible Nodes") 
  def hidden_nodes, do: Node.list(:hidden) |> display_nodes("Hidden Nodes") 
  def all_nodes, do: Node.list(:known) |> display_nodes("All Nodes")

  def autocluster do
    spawn(
      fn ->
        IO.puts "Starting node monitor process #{inspect self()}"
        :net_kernel.monitor_nodes true
        monitor_cluster()
      end
    )

    Application.ensure_all_started(:libcluster)
  end

  defp monitor_cluster do
    ExploringElixir.AutoCluster.visible_nodes()
    receive do
      {:nodeup, node} ->
        IO.puts good_news_marker() <> " Node joined: #{inspect node}"
        monitor_cluster()
      {:nodedown, node} ->
        IO.puts bad_news_marker() <> " Node departed: #{inspect node}"
        monitor_cluster()
      _ ->
        :ok
    end
  end

  defp display_nodes(nodes, title) do
    IO.puts "#{stars()} #{title} #{stars()}"
    display_nodes(nodes)
  end

  defp display_nodes([]), do: IO.puts "Not connected to any cluster. We are alone."
  defp display_nodes(nodes) when is_list(nodes) do
    IO.puts "Nodes in our cluster, including ourselves:"

    [Node.self()|nodes]
    |> Enum.sort
    |> Enum.dedup
    |> Enum.each(fn node -> IO.puts "     #{inspect node}" end)
  end

  defp good_news_marker, do: IO.ANSI.green() <> String.duplicate(<<0x1F603 :: utf8>>, 5) <> IO.ANSI.reset()
  defp bad_news_marker, do: IO.ANSI.red() <> String.duplicate(<<0x1F630 :: utf8>>, 5) <> IO.ANSI.reset()
  defp stars, do: String.duplicate "*", 10
end
