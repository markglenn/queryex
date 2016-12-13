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
end

