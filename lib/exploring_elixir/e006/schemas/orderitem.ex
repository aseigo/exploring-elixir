
defmodule ExploringElixir.Tenants.Schemas.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orderitems" do
    field :item_id, :integer
    field :amount, :integer, default: 1

    timestamps()

    belongs_to :order, ExploringElixir.Tenants.Schemas.Order
  end

  def changeset(order, params) do
    order
    |> cast(params, [:item_id, :amount, :order_id])
    |> validate_required([:item_id, :order_id])
  end
end

