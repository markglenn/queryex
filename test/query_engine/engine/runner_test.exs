defmodule QueryEngine.Engine.Runner.Test do
  use QueryEngine.ModelCase, async: true

  alias QueryEngine.Engine.Runner
  alias QueryEngine.Interface.Request

  alias QueryEngine.Query.Field
  alias QueryEngine.Query.Filter
  alias QueryEngine.Query.Association
  alias QueryEngine.Query.Order

  import QueryEngine.Factory

  describe "run" do
    test "empty request" do
      person = insert(:person)

      response =
        %Request{schema: Dummy.Person}
        |> Runner.run
        |> Dummy.Repo.all

      id = person.id
      assert [%Dummy.Person{id: ^id}] = response
    end

    test "preload request" do
      person = insert(:person)

      response =
        %Request{schema: Dummy.Person, side_loads: ["organization.country"]}
        |> Runner.run
        |> Dummy.Repo.all

      person_id = person.id
      organization_id = person.organization_id
      country_id = person.organization.country_id

      assert [%Dummy.Person{
        id: ^person_id,
        organization: %Dummy.Organization{
          id: ^organization_id,
          country: %Dummy.Country{id: ^country_id}
        }
      }] = response
    end

    test "filter request" do
      email_field = Field.from_path("email")
      filter = %Filter{field: email_field, operator: :=, value: "a"}

      person = insert(:person, email: "a")
      insert(:person, email: "b")

      response =
        %Request{schema: Dummy.Person, filters: [filter]}
        |> Runner.run
        |> Dummy.Repo.all

      person_id = person.id
      assert [%Dummy.Person{id: ^person_id}] = response
    end

    test "join request" do
      person = insert(:person)
      insert(:person)

      associations =
        "organization"
        |> Association.from_path
        |> Association.assign_bindings

      field =
        "organization.name"
        |> Field.from_path
        |> Field.set_association(associations)
      
      filter = %Filter{field: field, operator: :=, value: person.organization.name}

      response =
        %Request{schema: Dummy.Person, associations: associations, filters: [filter]}
        |> Runner.run
        |> Dummy.Repo.all

      person_id = person.id
      assert [%Dummy.Person{id: ^person_id}] = response
    end

    test "order request" do
      insert(:person, email: "b")
      insert(:person, email: "a")

      email_field = Field.from_path("email")

      order = %Order{field: email_field, direction: :asc}

      response =
        %Request{schema: Dummy.Person, sorts: [order, order]}
        |> Runner.run
        |> Dummy.Repo.all
        |> Enum.map(&(&1.email))

      assert ["a", "b"] == response

      # Test in reverse
      order = %Order{field: email_field, direction: :desc}
      response =
        %Request{schema: Dummy.Person, sorts: [order, order]}
        |> Runner.run
        |> Dummy.Repo.all
        |> Enum.map(&(&1.email))

      assert ["b", "a"] == response
    end
  end
end
