defmodule QueryEngine.Query.AssociationTest do
  use ExUnit.Case, async: true
  alias QueryEngine.Query.Association

  describe "from_path" do
    test "parses simple path" do
      [association | []] = Association.from_path("test")

      assert %Association{path: "test"} == association
    end

    test "parses path with parent" do
      [parent | [child]] = Association.from_path("person.organization")

      assert %Association{path: "person"} == parent
      assert %Association{path: "person.organization"} == child
    end

    test "parses path with 3 pieces" do
      [table1 | [table2 | [table3]]] = Association.from_path("table1.table2.table3")

      assert %Association{path: "table1"} == table1
      assert %Association{path: "table1.table2"} == table2
      assert %Association{path: "table1.table2.table3"} == table3
    end
  end

  describe "name" do
    test "with blank path" do
      assert Association.name(%Association{path: ""}) == nil
    end

    test "with simple path" do
      assert Association.name(%Association{path: "test"}) == :test
    end

    test "with advanced path" do
      assert Association.name(%Association{path: "test.subtest"}) == :subtest
    end
  end

  describe "assign_bindings" do
    test "with single association" do
      associations = [%Association{path: "test"}]

      [with_binding] = Association.assign_bindings(associations)

      assert with_binding.binding == 1
    end

    test "with multiple associations" do
      associations = [%Association{path: "test"}, %Association{path: "test2"}]

      [with_binding1, with_binding2] = Association.assign_bindings(associations)

      assert with_binding1.binding == 1
      assert with_binding2.binding == 2
    end
    
    test "with duplicate path associations" do
      associations = [%Association{path: "test"}, %Association{path: "test"}]

      [with_binding] = Association.assign_bindings(associations)

      assert with_binding.binding == 1
    end
  end

  describe "set_parent_bindings" do
    test "with standard list" do
      associations =
        "a.b"
        |> Association.from_path
        |> Association.assign_bindings

      assert Enum.at(associations, 0).binding == 1 
      assert Enum.at(associations, 0).parent_binding == 0 

      assert Enum.at(associations, 1).binding == 2
      assert Enum.at(associations, 1).parent_binding == 1
    end
  end
end
