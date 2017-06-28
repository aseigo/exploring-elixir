defmodule EctoBench.Table3 do
  use Ecto.Schema

  import Ecto.Changeset

  schema "table3" do
    field :c1, :string
    field :c2, :string
    field :c3, :string
    field :c4, :string
    field :c5, :string
    field :c6, :string
    field :c7, :string
    field :c8, :string
    field :c9, :string
    field :c10, :string
    field :c11, :string
    field :c12, :string
    field :c13, :string
    field :c14, :string
    field :c15, :string
    field :c16, :string
    field :c17, :string
    field :c18, :string
    field :c19, :string
    field :c20, :string
    field :c21, :string
    field :c22, :string
    field :c23, :string
    field :c24, :string
    field :c25, :string
    field :c26, :string
    field :c27, :string
    field :c28, :string
    field :c29, :string
    field :c30, :string
    field :c31, :string
    field :c32, :string
    field :c33, :string
    field :c34, :string
    field :c35, :string
    field :c36, :string
    field :c37, :string
    field :c38, :string
    field :c39, :string

    belongs_to :table1, EctoBench.Table1
  end

  def changeset(item, params) do
    item
    |> cast(params, [:c1, :c2, :c3, :c4, :c5, :c6, :c7, :c8, :c9, :c10, :c11, :c12, :c13, :c14, :c15, :c16, :c17, :c18, :c19, :c20, :c21, :c22, :c23, :c24, :c25, :c26, :c27, :c28, :c29, :c30, :c31, :c32, :c33, :c34, :c35, :c36, :c37, :c38, :c39])
  end
end
