defmodule Integration.Query.Test do
  use QueryEngine.ModelCase, async: true

  alias QueryEngine.Engine.Runner

  import QueryEngine.Factory

  test "simple request" do
    person = insert(:person)
    result =
      Dummy.Person
      |> QueryEngine.build
      |> Runner.run
      |> Dummy.Repo.one
      |> elem(0)

    assert result.id == person.id
  end

  test "simple filter" do
    person = insert(:person)
    insert(:person)

    result =
      Dummy.Person
      |> QueryEngine.build
      |> QueryEngine.filter("email", :=, person.email)
      |> Runner.run
      |> Dummy.Repo.one
      |> elem(0)

    assert result.id == person.id
  end

  test "complex filter" do
    insert(:person)
    person = insert(:person, organization: insert(:organization, name: "Test"))

    result =
      Dummy.Person
      |> QueryEngine.build
      |> QueryEngine.filter("organization.name", :=, "Test")
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
      Dummy.Person
      |> QueryEngine.build
      |> QueryEngine.filter("organization.name", :=, organization.name)
      |> QueryEngine.order_by("email", :desc)
      |> QueryEngine.order_by("organization.name", :asc)
      |> QueryEngine.side_load("organization")
      |> Runner.run
      |> Dummy.Repo.all
      |> Enum.map(&elem(&1, 0))

    assert [person2.id, person1.id] == Enum.map(result, &(&1.id))
    assert [organization.name, organization.name] == Enum.map(result, &(&1.organization.name))
  end
end
