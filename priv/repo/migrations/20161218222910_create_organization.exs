defmodule Dummy.Repo.Migrations.CreateOrganization do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string, null: false
      add :website, :string

      timestamps()
    end

    create unique_index(:organizations, [:name])
  end
end
