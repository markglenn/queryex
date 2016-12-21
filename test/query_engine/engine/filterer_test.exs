defmodule QueryEngine.Engine.FiltererTest do
  use QueryEngine.ModelCase, async: true
  require QueryEngine.Engine.Filterer

  alias QueryEngine.Engine.Joiner
  alias QueryEngine.Engine.Filterer

  alias QueryEngine.Query.Association
  alias QueryEngine.Query.Field
  alias QueryEngine.Query.Filter
  import QueryEngine.Factory

  describe "filter" do
    test "with simple filter" do
      person = insert(:person)
      field = Field.from_path("email")
      filter = %Filter{field: field, operator: "=", value: person.email}

      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query.email == person.email
    end

    test "with joined table" do
      organization = insert(:organization)
      person = insert(:person, organization: organization)

      associations =
        "organization"
        |> Association.from_path
        |> Association.assign_bindings

      field =
        "organization.name"
        |> Field.from_path
        |> Field.set_association(associations)
      
      filter = %Filter{field: field, operator: "=", value: organization.name}

      query =
        Dummy.Person
        |> Joiner.join(Enum.at(associations, 0))
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query.email == person.email
    end
  end
end
