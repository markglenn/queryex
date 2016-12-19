defmodule Dummy.Repo.Migrations.CreateCountry do
  use Ecto.Migration

  def change do
    create table(:countries) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:countries, [:name])
  end
end
