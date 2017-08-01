defmodule ExploringElixir.Tenants.Orders do
  use GenServer
  require Logger
  import Ecto.Query
  alias ExploringElixir.Tenants.Schemas.Order, as: OrderSchema
  alias ExploringElixir.Tenants.Schemas.OrderItem, as: OrderItemSchema
  alias ExploringElixir.Repo.Tenants, as: Repo

  @schema_meta_fields [:__meta__, :__struct__]

  def create_order(tenant, order_name) do
    if Triplex.exists? tenant, Repo do
      GenServer.start_link __MODULE__, {tenant, order_name}
    else
      {:error, :no_such_tenant}
    end
  end

  def fetch_order(tenant, order_id) do
    if Triplex.exists? tenant, Repo do
      GenServer.start_link __MODULE__, {tenant, order_id}
    else
      {:error, :no_such_tenant}
    end
  end

  def list_items(order) do
    GenServer.call(order, :list)
  end

  def add_item(order, item_id, amount) do
    GenServer.cast(order, {:add, item_id, amount})
  end

  def delete_item(order, item_id, amount) do
    GenServer.cast(order, {:delete, item_id, amount})
  end

  def list_orders(tenant) do
    query = from order in OrderSchema
    orders = Repo.all query, prefix: Triplex.to_prefix(tenant)
    for order <- orders, do: Map.drop(order, @schema_meta_fields)
  end

  def init({tenant, order_name}) when is_bitstring(order_name) do
    changeset = OrderSchema.changeset(%OrderSchema{}, %{name: order_name})

    case Repo.insert changeset, prefix: Triplex.to_prefix(tenant) do
      {:ok, %OrderSchema{id: order_id}} ->
        init({tenant, order_id})

      {:error, changeset} ->
        Logger.warn fn -> "Failed to create template with changeset: #{inspect changeset}" end
        {:stop, :order_creation_failed}
    end
  end

  def init({tenant, order_id}) when is_integer(order_id) do
    {:ok, %{tenant: tenant, order_id: order_id}}
  end

  def handle_call(:list, _from,
                  %{tenant: tenant, order_id: order_id} = state) do
    query = from i in OrderItemSchema,
            where: i.order_id == ^order_id
    items = Repo.all query, prefix: Triplex.to_prefix(tenant)
    items = for item <- items, do: Map.drop(item, @schema_meta_fields)
    {:reply, items, state}
  end

  def handle_cast({:add, item_id, amount},
                  %{tenant: tenant, order_id: order_id} = state) do
    # TODO add an item to the order
  end

  def handle_cast({:delete, item_id, amount},
                  %{tenant: tenant, order_id: order_id} = state) do
    # TODO delete the item from the order
  end
end
