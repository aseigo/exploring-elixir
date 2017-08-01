defmodule ExploringElixir.Tenants.Migrations.TenantOrderitems do
  use Ecto.Migration

  def change do
    create table(:orderitems) do
      add :item, :integer
      add :amount, :integer
      add :order_id, references(:orders, on_delete: :delete_all)
      
      timestamps()
    end
    
    create index(:orderitems, [:order_id])
  end
end
