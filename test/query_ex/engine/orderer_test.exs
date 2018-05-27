defmodule QueryEx.Engine.OrdererTest do
  use QueryEx.ModelCase, async: true
  doctest QueryEx.Engine.Orderer

  alias QueryEx.Engine.Joiner
  alias QueryEx.Engine.Orderer

  alias QueryEx.Query.Association
  alias QueryEx.Query.Field
  alias QueryEx.Query.Order

  import QueryEx.Factory

  describe "order" do
    setup do
      email_field = Field.from_path("email")

      [email_field: email_field]
    end

    test "with ascending order", %{email_field: field} do
      insert(:person, email: "A")
      insert(:person, email: "B")
      order = %Order{field: field, direction: :asc}

      query =
        Dummy.Person
        |> Orderer.order(order)
        |> Dummy.Repo.all
        |> Enum.map(&(&1.email))

      assert query == ["A", "B"]
    end
    
    test "with descending order", %{email_field: field} do
      insert(:person, email: "A")
      insert(:person, email: "B")
      order = %Order{field: field, direction: :desc}

      query =
        Dummy.Person
        |> Orderer.order(order)
        |> Dummy.Repo.all
        |> Enum.map(&(&1.email))

      assert query == ["B", "A"]
    end

    test "with joined table" do
      organization = insert(:organization, name: "A")
      person = insert(:person, organization: organization)

      organization2 = insert(:organization, name: "B")
      person2 = insert(:person, organization: organization2)

      associations =
        "organization"
        |> Association.from_path
        |> Association.assign_bindings

      field =
        "organization.name"
        |> Field.from_path
        |> Field.set_association(associations)
      
      order = %Order{field: field, direction: :asc}

      query =
        Dummy.Person
        |> Joiner.join(Enum.at(associations, 0))
        |> Orderer.order(order)
        |> Repo.all
        |> Enum.map(&(&1.id))

      assert query == [person.id, person2.id]
    end
  end
end


