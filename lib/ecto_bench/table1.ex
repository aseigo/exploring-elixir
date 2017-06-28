defmodule EctoBench.Table1 do
  use Ecto.Schema

  import Ecto.Changeset

  schema "table1" do
    field :truth, :boolean

    has_many :table2, EctoBench.Table2
    has_many :table3, EctoBench.Table3
  end

  def changeset(item, params) do
    item
    |> cast(params, [:truth])
  end
end
