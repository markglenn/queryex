defmodule Dummy.Person do
  use Ecto.Schema

  import Ecto.Changeset
  
  schema "people" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    belongs_to :organization, Dummy.Organization
    field :__count__, :integer, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email, :organization_id])
    |> validate_required([:first_name, :last_name, :email])
    |> unique_constraint(:email)
    |> foreign_key_constraint(:organization_id)
    |> validate_format(:email, ~r/@/)
  end
end

