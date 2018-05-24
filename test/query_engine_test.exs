defmodule QueryEngineTest do
  use ExUnit.Case, async: true
  doctest QueryEngine

  alias QueryEngine.Interface.Request
  alias QueryEngine.Query.Filter
  alias QueryEngine.Query.Order

  describe "build" do
    test "set the schema" do
      assert %Request{schema: Dummy.User} == QueryEngine.from_schema(Dummy.User)
    end
  end

  describe "filter" do
    test "set a single filter" do
      request =
        Dummy.User
        |> QueryEngine.from_schema
        |> QueryEngine.filter("table.column", :=, "test")

      assert %Request{filters: [%Filter{field: "table.column", operator: :=, value: "test"}]} = request
    end

    test "set multiple filters" do
      filters =
        Dummy.User
        |> QueryEngine.from_schema
        |> QueryEngine.filter("table.column", :=, "test")
        |> QueryEngine.filter("column", :like, "test%")
        |> Map.get(:filters)

      assert [
        %Filter{field: "column", operator: :like, value: "test%"},
        %Filter{field: "table.column", operator: :=, value: "test"}
      ] = filters
    end
  end

  describe "order_by" do
    test "set sort" do
      sorts =
        Dummy.User
        |> QueryEngine.from_schema
        |> QueryEngine.order_by("table.column", :asc)
        |> Map.get(:sorts)

      assert [%Order{field: "table.column", direction: :asc}] = sorts
    end

    test "set multiple sorts" do
      sorts =
        Dummy.User
        |> QueryEngine.from_schema
        |> QueryEngine.order_by("table.column", :asc)
        |> QueryEngine.order_by("column", :desc)
        |> Map.get(:sorts)

      assert [%Order{field: "column", direction: :desc}, %Order{field: "table.column", direction: :asc}] == sorts
    end
  end

  describe "side_load" do
    test "set side load" do
      side_loads =
        Dummy.User
        |> QueryEngine.from_schema
        |> QueryEngine.side_load("table")
        |> Map.get(:side_loads)

      assert ["table"] == side_loads
    end

    test "set multiple sorts" do
      side_loads =
        Dummy.User
        |> QueryEngine.from_schema
        |> QueryEngine.side_load("table1")
        |> QueryEngine.side_load("table2")
        |> Map.get(:side_loads)

      assert ["table2", "table1"] == side_loads
    end
  end

  describe "page" do
    test "set limit and offset" do
      request =
        Dummy.User
        |> QueryEngine.from_schema
        |> QueryEngine.page(10, 20)

      assert %Request{limit: 10, offset: 20} = request
    end

    test "set multiple sorts" do
      side_loads =
        Dummy.User
        |> QueryEngine.from_schema
        |> QueryEngine.side_load("table1")
        |> QueryEngine.side_load("table2")
        |> Map.get(:side_loads)

      assert ["table2", "table1"] == side_loads
    end
  end
end
