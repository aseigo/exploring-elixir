use Mix.Config

config :logger,
  level: :warn,
  compile_time_purge_level: :warn

config :exploring_elixir,
  ecto_repos: [EctoBench.Repo]

config :exploring_elixir, EctoBench.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ectobench",
  username: "aseigo",
  password: "",
  hostname: "localhost",
  size: 64

