defmodule Dummy.Repo.Migrations.CreatePerson do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, null: false

      timestamps()
    end
    
    create unique_index(:people, [:email])
  end
end
