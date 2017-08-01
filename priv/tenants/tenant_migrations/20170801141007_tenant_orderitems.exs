defmodule ExploringElixir.Repo.Tenants.Migrations.TenantOrderitems do
  use Ecto.Migration

  def change do
    create table(:orderitems) do
      add :item_id, :integer
      add :amount, :integer
      add :order_id, references(:orders, on_delete: :delete_all)
      
      timestamps()
    end

    create unique_index(:orderitems, [:order_id, :item_id])
  end
end
