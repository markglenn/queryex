defmodule QueryEngine.Query.AssociationTest do
  use ExUnit.Case, async: true
  alias QueryEngine.Query.Association

  describe "parse_path" do
    test "parses simple path" do
      [association | []] = Association.parse_path("test")

      assert %Association{name: "test", path: "test"} == association
    end

    test "parses path with parent" do
      [parent | [child]] = Association.parse_path("person.organization")

      assert %Association{name: "person", path: "person"} == parent
      assert %Association{name: "organization", path: "person.organization"} == child
    end

    test "parses path with 3 pieces" do
      [table1 | [table2 | [table3]]] = Association.parse_path("table1.table2.table3")

      assert %Association{name: "table1", path: "table1"} == table1
      assert %Association{name: "table2", path: "table1.table2"} == table2
      assert %Association{name: "table3", path: "table1.table2.table3"} == table3
    end
  end
end

