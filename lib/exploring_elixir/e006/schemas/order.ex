
defmodule ExploringElixir.Tenants.Schemas.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :name, :string
    timestamps()
  end

  def changeset(order, params) do
    order
    |> cast(params, [:name])
  end
end

