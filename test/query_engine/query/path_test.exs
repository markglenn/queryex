defmodule QueryEngine.Query.PathTest do
  use ExUnit.Case, async: true
  alias QueryEngine.Query.Path

  describe "parse" do
    test "with non-dotted path" do
      assert {"test", nil} == Path.parse("test")
    end

    test "with single parent path" do
      assert {"test", "parent"} == Path.parse("parent.test")
    end

    test "with long dotted path" do
      assert {"test", "a.b.c.d"} == Path.parse("a.b.c.d.test")
    end
  end
end
