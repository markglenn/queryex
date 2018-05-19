defmodule QueryEngine.Utils.MapUtils.Test do
  alias QueryEngine.Utils.MapUtils

  use ExUnit.Case, async: true

  describe "deep_merge" do
    test 'one level of maps without conflict' do
      result = MapUtils.deep_merge(%{a: 1}, %{b: 2})
      assert result == %{a: 1, b: 2}
    end

    test 'two levels of maps without conflict' do
      result = MapUtils.deep_merge(%{a: %{b: 1}}, %{a: %{c: 3}})
      assert result == %{a: %{b: 1, c: 3}}
    end

    test 'three levels of maps without conflict' do
      result = MapUtils.deep_merge(%{a: %{b: %{c: 1}}}, %{a: %{b: %{d: 2}}})
      assert result == %{a: %{b: %{c: 1, d: 2}}}
    end

    test 'non-map value in left' do
      result = MapUtils.deep_merge(%{a: 1}, %{a: %{b: 2}})
      assert result == %{a: %{b:  2}}
    end

    test 'non-map value in right' do
      result = MapUtils.deep_merge(%{a: %{b: 1}}, %{a: 2})
      assert result == %{a: 2}
    end

    test 'non-map value in both' do
      result = MapUtils.deep_merge(%{a: 1}, %{a: 2})
      assert result == %{a: 2}
    end
  end

  describe "list_to_deep_map" do
    test "empty list" do
      assert MapUtils.list_to_keyword_list([]) == nil
    end

    test "single list item" do
      assert MapUtils.list_to_keyword_list(["test"]) == :test
    end

    test "multiple item list" do
      assert MapUtils.list_to_keyword_list(["a", "b", "c"]) == [a: [b: :c]]
    end
  end
end
