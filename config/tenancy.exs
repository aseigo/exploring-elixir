use Mix.Config

config :exploring_elixir, ExploringElixir.Repo.Tenants,
  adapter: Ecto.Adapters.Postgres,
  database: "exploring_elixir_tenants",
  username: "postgres",
  password: "",
  hostname: "localhost"

config :triplex,
  tenant_prefix: "ee_"

