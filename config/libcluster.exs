use Mix.Config

config :libcluster,
  topologies: [
    exploring_elixir: [
      strategy: Cluster.Strategy.Gossip
      #config: {},
      #connect: {:net_kernel, :connect, []},
      #disconnect: {:net_kernel, :disconnect, []},
      #list_nodes: {:erlang, :nodes, [:connected]},
      #child_spec: [restart: :transient]
    ]
  ]
