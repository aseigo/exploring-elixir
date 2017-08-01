defmodule ExploringElixir.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      EctoBench.Repo,
      ExploringElixir.Tenants,
      ExploringElixir.ChildSpec,
      {ExploringElixir.ChildSpec, %{type: :forever}},
      {ExploringElixir.ChildSpec, %{type: :random}}
    ]

    opts = [strategy: :one_for_one, name: ExploringElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
