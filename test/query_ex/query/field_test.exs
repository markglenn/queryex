defmodule QueryEx.Query.FieldTest do
  use ExUnit.Case, async: true
  doctest QueryEx.Query.Field
  alias QueryEx.Query.Field
  alias QueryEx.Query.Association

  describe "from_path" do
    test "parses simple field with no path" do
      assert %Field{column: :test, association_path: nil} == Field.from_path("test")
    end

    test "parses field with simple path" do
      assert %Field{column: :test, association_path: "association"} ==
        Field.from_path("association.test")
    end

    test "parses field with dotted path" do
      assert %Field{column: :test, association_path: "parent.association"} ==
        Field.from_path("parent.association.test")
    end
  end

  describe "set_association" do
    test "assigns nil if no association path" do
      field = Field.from_path("test")
      assert %Field{association: nil} = Field.set_association(field, [])
    end

    test "assigns nil if association path not found" do
      field = Field.from_path("parent.test")
      assert %Field{association: nil} = Field.set_association(field, [])
    end

    test "assigns association if association path found" do
      field = Field.from_path("parent.test")
      association = Enum.at(Association.from_path("parent"), 0)
      assert %Field{association: ^association} = Field.set_association(field, [association])
    end
  end
end
