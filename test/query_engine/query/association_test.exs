defmodule QueryEngine.Query.AssociationTest do
  use ExUnit.Case, async: true
  alias QueryEngine.Query.Association

  describe "path" do
    test "returns name if no parent" do
      association = %Association{name: "test", binding: 1}

      assert Association.path(association) == "test"
    end

    test "returns name with single parent" do
      parent = %Association{name: "parent"}
      association = %Association{name: "test", binding: 1, parent: parent}

      assert Association.path(association) == "parent.test"
    end

    test "returns name with grand parent" do
      grandparent = %Association{name: "grandparent"}
      parent = %Association{name: "parent", parent: grandparent}
      association = %Association{name: "test", binding: 1, parent: parent}

      assert Association.path(association) == "grandparent.parent.test"
    end
  end
  
  describe "parse_path" do
    test "parses simple path" do
      [association | []] = Association.parse_path("test")

      assert %Association{name: "test", path: "test"} == association
    end

    test "parses path with parent" do
      [parent | [child]] = Association.parse_path("person.organization")

      assert %Association{name: "person", path: "person"} == parent
      assert %Association{name: "organization", path: "person.organization", parent: parent} == child
    end

    test "parses path with 3 pieces" do
      [table1 | [table2 | [table3]]] = Association.parse_path("table1.table2.table3")

      assert %Association{name: "table1", path: "table1"} == table1
      assert %Association{name: "table2", path: "table1.table2", parent: table1} == table2
      assert %Association{name: "table3", path: "table1.table2.table3", parent: table2} == table3
    end
  end
end

