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

  def delete_item(order, item_id) do
    GenServer.cast(order, {:delete, item_id})
  end

  def delete_item(order, item_id, amount) do
    GenServer.cast(order, {:delete, item_id, amount})
  end

  def list_orders(tenant) do
    query = from order in OrderSchema
    orders = Repo.all query, prefix: Triplex.to_prefix(tenant)
    for order <- orders, do: Map.drop(order, @schema_meta_fields)
  end

  def id(order), do: GenServer.call order, :id

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
    query = from o in "orders",
            where: o.id == ^order_id,
            select: o.id
    case Repo.one query, prefix: Triplex.to_prefix(tenant) do
      nil -> {:stop, :no_such_order}
        _ -> {:ok, %{tenant: tenant, order_id: order_id}}
    end
  end

  def handle_call(:list, _from,
                  %{tenant: tenant, order_id: order_id} = state) do
    items =
      from(i in "orderitems",
           where: i.order_id == ^order_id,
           select: %{item: i.item_id, order: i.order_id, amount: i.amount})
      |> Repo.all(prefix: Triplex.to_prefix(tenant))

    {:reply, items, state}
  end

  def handle_call(:id, _from, %{order_id: order_id} = state) do
    {:reply, order_id, state}
  end

  def handle_cast({:add, item_id, amount},
                  %{tenant: tenant, order_id: order_id} = state) do
    changeset = OrderItemSchema.changeset %OrderItemSchema{},
                                          %{item_id: item_id,
                                            order_id: order_id,
                                            amount: amount}

    Repo.insert! changeset,
                 prefix: Triplex.to_prefix(tenant),
                 conflict_target: [:order_id, :item_id],
                 on_conflict: [inc: [amount: amount]]

    {:noreply, state}
  end

  def handle_cast({:delete, item_id},
                  %{tenant: tenant, order_id: order_id} = state) do
    from(i in "orderitems",
         where: [order_id: ^order_id, item_id: ^item_id])
    |> Repo.delete_all(prefix: Triplex.to_prefix(tenant))
    {:noreply, state}
  end

  def handle_cast({:delete, item_id, amount},
                  %{tenant: tenant, order_id: order_id} = state) do
    from(i in "orderitems",
         where: [order_id: ^order_id, item_id: ^item_id])
    |> Repo.update_all([inc: [amount: -amount]], [prefix: Triplex.to_prefix(tenant)])

    {:noreply, state}
  end
end
