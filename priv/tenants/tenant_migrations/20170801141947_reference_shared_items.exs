defmodule ExploringElixir.Repo.Tenants.Migrations.ReferenceSharedItems do
  use Ecto.Migration

  @fk_name "order_items_fkey"
  @repo ExploringElixir.Repo.Tenants

  def up do
    %{prefix: prefix} = Process.get(:ecto_migration)
    query = "alter table #{prefix}.orderitems
             add constraint #{@fk_name} foreign key (item_id)
             references public.items(id)"

   Ecto.Adapters.SQL.query!(@repo, query, [])
  end

  def down do
    %{prefix: prefix} = Process.get(:ecto_migration)
    query = "ALTER TABLE #{prefix}.orderitems
             DROP CONSTRAINT IF EXISTS #{@fk_name}"

   Ecto.Adapters.SQL.query!(@repo, query, [])
  end
end
