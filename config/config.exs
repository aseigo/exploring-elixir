use Mix.Config

config :exploring_elixir, ExploringElixir.Repo.Tenants,
  adapter: Ecto.Adapters.Postgres,
  database: "exploring_elixir_tenants",
  username: "aseigo",
  password: "",
  hostname: "localhost"

config :exploring_elixir, EctoBench.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ectobench",
  username: "aseigo",
  password: "",
  hostname: "localhost",
  size: 64

config :exploring_elixir,
  ecto_repos: [EctoBench.Repo, ExploringElixir.Repo.Tenants]

config :triplex,
  tenant_prefix: "ee_"

import_config "#{Mix.env}.exs"
