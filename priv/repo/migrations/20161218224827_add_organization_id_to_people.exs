defmodule Dummy.Repo.Migrations.AddOrganizationIdToPeople do
  use Ecto.Migration

  def change do
    alter table(:people) do
      add :organization_id, references(:organizations)
    end
  end
end
