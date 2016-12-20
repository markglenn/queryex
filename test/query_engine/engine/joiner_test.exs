defmodule QueryEngine.Engine.JoinerTest do
  use QueryEngine.ModelCase, async: true
  require IEx
  require QueryEngine.Engine.Joiner

  alias QueryEngine.Engine.Joiner
  alias QueryEngine.Query.Association
  import QueryEngine.Factory

  describe "join" do
    test "joins simple association" do
      organization = insert(:organization)
      person = insert(:person, organization: organization)

      association = %Association{name: :organization, path: "organization", binding: 1}

      query = Joiner.join(Dummy.Person, association, quote do: association.binding)

      query_person =
        query
        |> where([_, o], o.name == ^organization.name)
        |> Dummy.Repo.one

      assert query_person.id == person.id
    end

    test "joins complex association" do
      country = insert(:country)
      organization = insert(:organization, country: country)
      person = insert(:person, organization: organization)

      association1 = %Association{name: :organization, path: "organization", binding: 1}
      association2 = %Association{name: :country, path: "organization.country", binding: 2}

      query = Joiner.join(Dummy.Person, association1, association1.binding)
      query = Joiner.join(query, association2, association2.binding)

      query_person =
        query
        |> where([_, _, c], c.name == ^country.name)
        |> Dummy.Repo.one

      assert query_person.id == person.id
    end
  end
end

