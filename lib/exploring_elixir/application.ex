defmodule ExploringElixir.Application do
  @moduledoc false

  use Application
  #import Supervisor.Spec

  def start(_type, _args) do
    children = [
      ExploringElixir.OneFive
      #supervisor(EctoBench.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: ExploringElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
