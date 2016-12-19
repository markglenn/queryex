defmodule QueryEngine.Engine.JoinerTest do
  use QueryEngine.ModelCase, async: true
  require IEx

  alias QueryEngine.Engine.Joiner
  alias QueryEngine.Query.Association
  import QueryEngine.Factory

  describe "join" do
    test "joins simple association" do
      organization = insert(:organization)
      person = insert(:person, organization: organization)

      association = %Association{name: :organization, path: "organization"}

      query = Joiner.join(Dummy.Person, association)

      query_person =
        query
        |> where([_, o], o.name == ^organization.name)
        |> Dummy.Repo.one

      assert query_person.id == person.id
    end
  end
end

