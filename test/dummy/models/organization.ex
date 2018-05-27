defmodule Dummy.Organization do
  @moduledoc """
  Test model
  """

  use Ecto.Schema

  import Ecto.Changeset
  
  schema "organizations" do
    field :name, :string
    field :website, :string
    belongs_to :country, Dummy.Country

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :website, :country_id])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end

