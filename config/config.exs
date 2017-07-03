use Mix.Config

config :exploring_elixir,
  ecto_repos: [EctoBench.Repo]

config :exploring_elixir, EctoBench.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ectobench",
  username: "aseigo",
  password: "",
  hostname: "localhost",
  size: 64

import_config "#{Mix.env}.exs"

