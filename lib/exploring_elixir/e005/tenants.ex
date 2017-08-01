defmodule ExploringElixir.Tenants do
  use Ecto.Repo, otp_app: :exploring_elixir

  def child_spec(opts) do
    %{
          id: __MODULE__,
          start: {__MODULE__, :start_link, [opts]},
          type: :supervisor
     }
  end
end
