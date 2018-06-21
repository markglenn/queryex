defmodule QueryEx.Query.AssociationTest do
  use ExUnit.Case, async: true
  doctest QueryEx.Query.Association

  alias QueryEx.Query.Association

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

      [with_binding] = Association.assign_bindings(associations, 0)

      assert with_binding.binding == 1
    end

    test "with multiple associations" do
      associations = [%Association{path: "test"}, %Association{path: "test2"}]

      [with_binding1, with_binding2] = Association.assign_bindings(associations, 0)

      assert with_binding1.binding == 1
      assert with_binding2.binding == 2
    end

    test "with duplicate path associations" do
      associations = [%Association{path: "test"}, %Association{path: "test"}]

      [with_binding] = Association.assign_bindings(associations, 0)

      assert with_binding.binding == 1
    end
  end

  describe "set_parent_bindings" do
    test "with standard list" do
      associations =
        "a.b"
        |> Association.from_path()
        |> Association.assign_bindings(0)

      assert Enum.at(associations, 0).binding == 1
      assert Enum.at(associations, 0).parent_binding == 0

      assert Enum.at(associations, 1).binding == 2
      assert Enum.at(associations, 1).parent_binding == 1
    end
  end

  describe "from_side_loads" do
    test "parse single side load" do
      assert Association.from_side_loads(["organization"]) == [:organization]
    end

    test "parse deeper side load" do
      assert Association.from_side_loads(["organization.country"]) == [{:organization, :country}]
    end

    test "duplicates" do
      assert Association.from_side_loads(["organization", "organization"]) == [:organization]
    end

    test "overlapping side loads" do
      assert Association.from_side_loads(["organization.country", "organization"]) == [
               {:organization, :country}
             ]

      assert Association.from_side_loads(["organization", "organization.country"]) == [
               {:organization, :country}
             ]
    end

    test "non overlapping side loads" do
      assert Association.from_side_loads(["organization.country", "person"]) == [
               {:organization, :country},
               :person
             ]
    end

    test "long side loads" do
      assert Association.from_side_loads(["table1.table2.table3.table4.table5", "table1.table6"]) ==
               [{:table1, [{:table2, [table3: [table4: :table5]]}, :table6]}]
    end
  end
end
