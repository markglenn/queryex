defmodule QueryExTest do
  use ExUnit.Case, async: true
  doctest QueryEx

  alias QueryEx.Interface.Request
  alias QueryEx.Query.Filter
  alias QueryEx.Query.Order

  describe "build" do
    test "set the schema" do
      assert %Request{schema: Dummy.Person} == QueryEx.from_schema(Dummy.Person)
    end
  end

  describe "filter" do
    test "set a single filter" do
      request =
        Dummy.Person
        |> QueryEx.from_schema
        |> QueryEx.filter("table.column", :=, "test")

      assert %Request{filters: [%Filter{field: "table.column", operator: :=, value: "test"}]} = request
    end

    test "set multiple filters" do
      filters =
        Dummy.Person
        |> QueryEx.from_schema
        |> QueryEx.filter("table.column", :=, "test")
        |> QueryEx.filter("column", :like, "test%")
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
        Dummy.Person
        |> QueryEx.from_schema
        |> QueryEx.order_by("table.column", :asc)
        |> Map.get(:sorts)

      assert [%Order{field: "table.column", direction: :asc}] = sorts
    end

    test "set multiple sorts" do
      sorts =
        Dummy.Person
        |> QueryEx.from_schema
        |> QueryEx.order_by("table.column", :asc)
        |> QueryEx.order_by("column", :desc)
        |> Map.get(:sorts)

      assert [%Order{field: "column", direction: :desc}, %Order{field: "table.column", direction: :asc}] == sorts
    end
  end

  describe "side_load" do
    test "set side load" do
      side_loads =
        Dummy.Person
        |> QueryEx.from_schema
        |> QueryEx.side_load("table")
        |> Map.get(:side_loads)

      assert ["table"] == side_loads
    end

    test "set multiple sorts" do
      side_loads =
        Dummy.Person
        |> QueryEx.from_schema
        |> QueryEx.side_load("table1")
        |> QueryEx.side_load("table2")
        |> Map.get(:side_loads)

      assert ["table2", "table1"] == side_loads
    end
  end

  describe "page" do
    test "set limit and offset" do
      request =
        Dummy.Person
        |> QueryEx.from_schema
        |> QueryEx.page(10, 20)

      assert %Request{limit: 10, offset: 20} = request
    end

    test "set multiple sorts" do
      side_loads =
        Dummy.Person
        |> QueryEx.from_schema
        |> QueryEx.side_load("table1")
        |> QueryEx.side_load("table2")
        |> Map.get(:side_loads)

      assert ["table2", "table1"] == side_loads
    end
  end
end
