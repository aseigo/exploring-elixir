defmodule ExploringElixir.Repo.Tenants.Migrations.DatesAndTimes do
  use Ecto.Migration

  def change do
    create table(:dates_and_times) do
      add :a_date, :date
      add :a_time, :time
      add :with_tz, :timestamptz
      add :data, :text
    end
  end
end
