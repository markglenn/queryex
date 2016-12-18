defmodule Dummy.PersonTest do
  use QueryEngine.ModelCase, async: true
  import QueryEngine.Factory

  alias Dummy.Person

  test "changeset with valid attributes" do
    changeset = Person.changeset(%Person{}, params_for(:person))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Person.changeset(%Person{}, %{})
    refute changeset.valid?
  end

  test "changeset with invalid organization id" do
    changeset = Person.changeset(%Person{}, params_for(:person, organization_id: 0))

    assert {:error, _} = Dummy.Repo.insert(changeset)
  end

  test "changeset with valid organization" do
    organization = insert(:organization)
    changeset = Person.changeset(%Person{}, params_for(:person, organization_id: organization.id))

    assert {:ok, _} = Dummy.Repo.insert(changeset)
  end
end
