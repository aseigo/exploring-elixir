defmodule ExploringElixir.Repo.Tenants.Migrations.ConstrainItemCounts do
  use Ecto.Migration

  @repo ExploringElixir.Repo.Tenants
  
  def up do
    %{prefix: prefix} = Process.get(:ecto_migration)
    query = "CREATE OR REPLACE FUNCTION remove_empties_from_orders()
             RETURNS trigger AS
             $$
             BEGIN
              DELETE FROM #{prefix}.orderitems WHERE id = NEW.id AND item_id = NEW.item_id;
              RETURN NULL;
             END
             $$ LANGUAGE plpgsql"

    Ecto.Adapters.SQL.query!(@repo, query, [])
   
    query = "CREATE TRIGGER remove_empty_items 
             AFTER UPDATE OF amount
             ON #{prefix}.orderitems
             FOR EACH ROW
             WHEN (NEW.amount < 1)
             EXECUTE PROCEDURE remove_empties_from_orders()"

    Ecto.Adapters.SQL.query!(@repo, query, [])
  end
  
  def down do
    query = "DROP FUNCTION remove_empties_from_orders() CASCADE"
    Ecto.Adapters.SQL.query!(@repo, query, [])
  end
end
