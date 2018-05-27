defmodule Dummy.Country do
  @moduledoc """
  Test model
  """

  use Ecto.Schema

  import Ecto.Changeset
  
  schema "countries" do
    field :name, :string
    has_many :organizations, Dummy.Organization

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
