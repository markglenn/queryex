defmodule QueryEngine.Engine.Pager.Test do
  use QueryEngine.ModelCase, async: true

  import QueryEngine.Factory

  alias QueryEngine.Engine.Orderer
  alias QueryEngine.Engine.Pager

  alias QueryEngine.Query.Field
  alias QueryEngine.Query.Order

  describe "page" do
    setup do
      sort = %Order{field: %Field{column: :id}, direction: :asc}
      [people: insert_list(5, :person), sort: sort]
    end

    test "with default parameters", %{sort: sort} do
      query =
        Dummy.Person
        |> Pager.page(nil, nil)
        |> Orderer.order(sort)
        |> Dummy.Repo.all

      assert length(query) == 5
    end

    test "with limit", %{people: people, sort: sort} do
      query =
        Dummy.Person
        |> Orderer.order(sort)
        |> Pager.page(2, nil)
        |> Dummy.Repo.all

      assert Enum.map(query, &(&1.id)) == Enum.map(Enum.take(people, 2), &(&1.id))
    end

    test "with offset", %{people: people, sort: sort} do
      query =
        Dummy.Person
        |> Orderer.order(sort)
        |> Pager.page(nil, 2)
        |> Dummy.Repo.all

      assert Enum.map(query, &(&1.id)) == Enum.map(Enum.drop(people, 2), &(&1.id))
    end

    test "with limit and offset", %{people: people, sort: sort} do
      query =
        Dummy.Person
        |> Orderer.order(sort)
        |> Pager.page(2, 2)
        |> Dummy.Repo.all

      assert Enum.map(query, &(&1.id)) == 
        people
        |> Enum.drop(2)
        |> Enum.take(2)
        |> Enum.map(&(&1.id))
    end

  end
end
