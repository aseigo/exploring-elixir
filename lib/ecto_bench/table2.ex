defmodule EctoBench.Table2 do
  use Ecto.Schema

  import Ecto.Changeset

  schema "table2" do
    field :chars, :string
    field :textual, :string
    field :count, :integer, default: 0

    belongs_to :table1, EctoBench.Table1
  end

  def changeset(item, params) do
    item
    |> cast(params, [:chars, :textual, :count])
  end
end
