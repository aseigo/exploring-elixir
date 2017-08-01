defmodule EctoBench.Repo.Migrations.TenantOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :name, :text

      timestamps()
    end
  end
end
