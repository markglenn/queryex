defmodule Dummy.Organization do
  use Ecto.Schema

  import Ecto.Changeset
  
  schema "organizations" do
    field :name, :string
    field :website, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :website])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end

