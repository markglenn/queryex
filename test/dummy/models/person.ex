defmodule Dummy.Person do
  use Ecto.Schema

  import Ecto
  import Ecto.Changeset
  import Ecto.Query
  
  schema "people" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email])
    |> validate_required([:first_name, :last_name, :email])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
  end
end

