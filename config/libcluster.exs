use Mix.Config

config :libcluster,
  topologies: [
    exploring_elixir: [
      strategy: Cluster.Strategy.Gossip,
      #config: {},
      connect: {ExploringElixir.AutoCluster, :connect_node, []},
      disconnect: {ExploringElixir.AutoCluster, :disconnect_node, []},
      #list_nodes: {:erlang, :nodes, [:connected]},
      #child_spec: [restart: :transient]
    ]
  ]
