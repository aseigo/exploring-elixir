defmodule ExploringElixir.AutoCluster do
  def visible_nodes, do: Node.list() |> display_nodes("Visible Nodes") 
  def hidden_nodes, do: Node.list(:hidden) |> display_nodes("Hidden Nodes") 
  def all_nodes, do: Node.list(:known) |> display_nodes("All Nodes")

  def autocluster, do: Application.ensure_all_started(:libcluster)

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

  defp stars, do: String.duplicate "*", 10
end
