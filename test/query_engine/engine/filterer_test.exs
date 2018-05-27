defmodule QueryEngine.Engine.FiltererTest do
  use QueryEngine.ModelCase, async: true
  doctest QueryEngine.Engine.Filterer

  require QueryEngine.Engine.Filterer
  alias QueryEngine.Engine.Joiner
  alias QueryEngine.Engine.Filterer

  alias QueryEngine.Query.Association
  alias QueryEngine.Query.Field
  alias QueryEngine.Query.Filter
  import QueryEngine.Factory

  describe "filter" do
    setup do
      email_field = Field.from_path("email")
      id_field = Field.from_path("id")
      organization_id_field = Field.from_path("organization_id")

      [email_field: email_field, id_field: id_field, organization_id_field: organization_id_field]
    end

    test "with simple filter", %{email_field: field} do
      person = insert(:person)
      filter = %Filter{field: field, operator: :=, value: person.email}

      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query.email == person.email
    end

    test "with == nil", %{organization_id_field: organization_field, email_field: email_field} do
      person = insert(:person, organization: nil)

      filter = %Filter{field: organization_field, operator: :=, value: nil}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query.id == person.id

      # Negative test
      filter = %Filter{field: email_field, operator: :=, value: nil}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query == nil
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
      
      filter = %Filter{field: field, operator: :=, value: organization.name}

      query =
        Dummy.Person
        |> Joiner.join(Enum.at(associations, 0))
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query.email == person.email
    end

    test "with !=", %{email_field: field} do
      person = insert(:person)

      # Positive test
      filter = %Filter{field: field, operator: :!=, value: person.email <> "1"}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query.id == person.id

      # Negative test
      filter = %Filter{field: field, operator: :!=, value: person.email}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query == nil
    end

    test "with != nil", %{email_field: field, organization_id_field: organization_field} do
      person = insert(:person, organization: nil)

      # Positive test
      filter = %Filter{field: field, operator: :!=, value: nil}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query.id == person.id

      # Negative test
      filter = %Filter{field: organization_field, operator: :!=, value: nil}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query == nil
    end

    test "with >", %{id_field: field} do
      person = insert(:person)

      # Positive test
      filter = %Filter{field: field, operator: :>, value: person.id - 1}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query.id == person.id

      # Negative test
      filter = %Filter{field: field, operator: :>, value: person.id}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query == nil
    end
    
    test "with <", %{id_field: field} do
      person = insert(:person)

      # Positive test
      filter = %Filter{field: field, operator: :<, value: person.id + 1}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query.id == person.id

      # Negative test
      filter = %Filter{field: field, operator: :<, value: person.id}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query == nil
    end

    test "with like", %{email_field: field} do
      person = insert(:person, email: "liketest@example.com")

      # Positive test
      filter = %Filter{field: field, operator: :like, value: "like%"}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query.id == person.id

      # Negative test
      filter = %Filter{field: field, operator: :like, value: "notlike%"}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query == nil
    end

    test "with not like", %{email_field: field} do
      person = insert(:person, email: "liketest@example.com")

      # Positive test
      filter = %Filter{field: field, operator: :not_like, value: "notlike%"}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query.id == person.id

      # Negative test
      filter = %Filter{field: field, operator: :not_like, value: "like%"}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query == nil
    end

    
    test "with >=", %{id_field: field} do
      person = insert(:person)

      # Positive test
      filter = %Filter{field: field, operator: :>=, value: person.id - 1}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query.id == person.id

      # Negative test
      filter = %Filter{field: field, operator: :>=, value: person.id + 1}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query == nil
    end
    
    test "with <=", %{id_field: field} do
      person = insert(:person)

      # Positive test
      filter = %Filter{field: field, operator: :<=, value: person.id + 1}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query.id == person.id

      # Negative test
      filter = %Filter{field: field, operator: :<=, value: person.id - 1}
      query =
        Dummy.Person
        |> Filterer.filter(filter)
        |> Dummy.Repo.one

      assert query == nil
    end
  end
end
