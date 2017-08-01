defmodule ExploringElixir.Repo.Tenants.Migrations.Items do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :text
    end
  end
end
