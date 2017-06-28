defmodule EctoBench.Repo.Migrations.AddEctobenchTables do
  use Ecto.Migration

  def change do
    create table(:table1) do
      add :truth, :boolean
    end

    create table(:table2) do
      add :chars, :string, size: 32
      add :textual, :text
      add :count, :integer
      add :ref, references(:table1, on_delete: :delete_all)
    end

    create table(:table3) do
      add :c1, :string
      add :c2, :string
      add :c3, :string
      add :c4, :string
      add :c5, :string
      add :c6, :string
      add :c7, :string
      add :c8, :string
      add :c9, :string
      add :c10, :string
      add :c11, :string
      add :c12, :string
      add :c13, :string
      add :c14, :string
      add :c15, :string
      add :c16, :string
      add :c17, :string
      add :c18, :string
      add :c19, :string
      add :c20, :string
      add :c21, :string
      add :c22, :string
      add :c23, :string
      add :c24, :string
      add :c25, :string
      add :c26, :string
      add :c27, :string
      add :c28, :string
      add :c29, :string
      add :c30, :string
      add :c31, :string
      add :c32, :string
      add :c33, :string
      add :c34, :string
      add :c35, :string
      add :c36, :string
      add :c37, :string
      add :c38, :string
      add :c39, :string
      add :ref, references(:table1, on_delete: :delete_all)
    end
  end
end
