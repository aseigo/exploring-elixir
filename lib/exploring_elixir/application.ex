defmodule ExploringElixir.Application do
  @moduledoc false

  use Application
  #import Supervisor.Spec

  def start(_type, _args) do
    children = [
      ExploringElixir.ChildSpec,
      {ExploringElixir.ChildSpec, %{type: :forever}},
      {ExploringElixir.ChildSpec, %{type: :rand}}
    ]

    opts = [strategy: :one_for_one, name: ExploringElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
