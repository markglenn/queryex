defmodule QueryEx.Engine.Builder.Test do
  use QueryEx.ModelCase, async: true
  doctest QueryEx.Engine.Builder

  alias QueryEx.Engine.Builder
  alias QueryEx.Interface.Request

  alias QueryEx.Query.Filter
  alias QueryEx.Query.Order

  import QueryEx.Factory

  describe "build" do
    test "empty request" do
      person = insert(:person)

      response =
        %Request{base_query: Dummy.Person}
        |> Builder.build
        |> Dummy.Repo.all
        |> Enum.map(&elem(&1, 0))

      id = person.id
      assert [%{id: ^id}] = response
    end

    test "preload request" do
      person = insert(:person)

      response =
        %Request{base_query: Dummy.Person, side_loads: ["organization.country"]}
        |> Builder.build
        |> Dummy.Repo.all
        |> Enum.map(&elem(&1, 0))

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
      filter = %Filter{field: "email", operator: :=, value: "a"}

      person = insert(:person, email: "a")
      insert(:person, email: "b")

      response =
        %Request{base_query: Dummy.Person, filters: [filter]}
        |> Builder.build
        |> Dummy.Repo.all
        |> Enum.map(&elem(&1, 0))

      person_id = person.id
      assert [%{id: ^person_id}] = response
    end

    test "join request" do
      person = insert(:person)
      insert(:person)

      filter = %Filter{field: "organization.name", operator: :=, value: person.organization.name}

      response =
        %Request{base_query: Dummy.Person, filters: [filter]}
        |> Builder.build
        |> Dummy.Repo.all
        |> Enum.map(&elem(&1, 0))

      person_id = person.id
      assert [%{id: ^person_id}] = response
    end

    test "order request" do
      insert(:person, email: "b")
      insert(:person, email: "a")

      order = %Order{field: "email", direction: :asc}

      response =
        %Request{base_query: Dummy.Person, sorts: [order]}
        |> Builder.build
        |> Dummy.Repo.all
        |> Enum.map(&(elem(&1, 0).email))

      assert ["a", "b"] == response

      # Test in reverse
      order = %Order{field: "email", direction: :desc}
      response =
        %Request{base_query: Dummy.Person, sorts: [order]}
        |> Builder.build
        |> Dummy.Repo.all
        |> Enum.map(&elem(&1, 0))
        |> Enum.map(&(&1.email))

      assert ["b", "a"] == response
    end
  end
end
