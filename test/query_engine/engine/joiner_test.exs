defmodule QueryEngine.Engine.JoinerTest do
  use QueryEngine.ModelCase, async: true

  alias QueryEngine.Engine.Joiner
  alias QueryEngine.Query.Association
  import QueryEngine.Factory

  describe "join" do
    test "joins simple association" do
      organization = insert(:organization)
      person = insert(:person, organization: organization)

      associations =
        "organization"
        |> Association.from_path
        |> Association.assign_bindings

      query_person =
        Dummy.Person
        |> Joiner.join(Enum.at(associations, 0))
        |> where([_, o], o.name == ^organization.name)
        |> Dummy.Repo.one

      assert query_person.id == person.id
    end

    test "joins complex association" do
      country = insert(:country)
      organization = insert(:organization, country: country)
      person = insert(:person, organization: organization)

      associations =
        "organization.country"
        |> Association.from_path
        |> Association.assign_bindings

      query_person =
        Dummy.Person
        |> Joiner.join(Enum.at(associations, 0))
        |> Joiner.join(Enum.at(associations, 1))
        |> where([_, _, c], c.name == ^country.name)
        |> Dummy.Repo.one

      assert query_person.id == person.id
    end
  end
end

