defmodule Integration.Query.Test do
  use QueryEngine.ModelCase, async: true

  alias QueryEngine.Parser.ApiParser
  alias QueryEngine.Engine.Runner

  import QueryEngine.Factory

  test "simple request" do
    person = insert(:person)
    result =
      ""
      |> ApiParser.parse(Dummy.Person)
      |> Runner.run
      |> Dummy.Repo.one
      |> elem(0)

    assert result.id == person.id
  end

  test "simple filter" do
    person = insert(:person)
    insert(:person)

    result =
      %{
        filters: [%{operand: "email", operator: "=", value: person.email}]
      }
      |> Poison.encode!
      |> ApiParser.parse(Dummy.Person)
      |> Runner.run
      |> Dummy.Repo.one
      |> elem(0)

    assert result.id == person.id
  end

  test "complex filter" do
    insert(:person)
    person = insert(:person, organization: insert(:organization, name: "Test"))

    result =
      %{
        filters: [%{operand: "organization.name", operator: "=", value: "Test"}]
      }
      |> Poison.encode!
      |> ApiParser.parse(Dummy.Person)
      |> Runner.run
      |> Dummy.Repo.one
      |> elem(0)

    assert result.id == person.id
  end

  test "kitchen sink" do
    organization = insert(:organization)
    person1 = insert(:person, email: "a", organization: organization)
    person2 = insert(:person, email: "b", organization: organization)
    insert(:person)

    result =
      %{
        filters: [%{operand: "organization.name", operator: "=", value: organization.name}],
        order: [%{column: "email", direction: :desc}, %{column: "organization.name", direction: :asc}],
        includes: ["organization"]
      }
      |> Poison.encode!
      |> ApiParser.parse(Dummy.Person)
      |> Runner.run
      |> Dummy.Repo.all
      |> Enum.map(&elem(&1, 0))

    assert [person2.id, person1.id] == Enum.map(result, &(&1.id))
    assert [organization.name, organization.name] == Enum.map(result, &(&1.organization.name))
  end
end
