use Mix.Config

config :exploring_elixir, EctoBench.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ectobench",
  username: "postgres",
  password: "",
  hostname: "localhost",
  size: 64

