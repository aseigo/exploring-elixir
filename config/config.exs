use Mix.Config

import_config "ecto_perf.exs"
import_config "tenancy.exs"
import_config "libcluster.exs"

config :exploring_elixir,
  ecto_repos: [EctoBench.Repo, ExploringElixir.Repo.Tenants]

import_config "#{Mix.env}.exs"
