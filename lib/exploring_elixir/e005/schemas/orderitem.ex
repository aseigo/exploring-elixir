
defmodule ExploringElixir.Tenants.Schemas.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orderitems" do
    field :item_id, :string
    field :amount, :integer

    timestamps()

    belongs_to :order, ExploringElixir.Tenants.Schemas.Order
  end

  def changeset(order, params) do
    order
    |> cast(params, [:name])
  end
end

