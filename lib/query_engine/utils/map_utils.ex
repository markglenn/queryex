defmodule QueryEngine.Utils.MapUtils do
  def deep_merge(left, right) do
    Map.merge(left, right, &deep_resolve/3)
  end

  # Convert ["a", "b", "c"] => [a: [b: :c]]
  def list_to_keyword_list([]), do: nil
  def list_to_keyword_list([head | []]), do: String.to_atom(head)
  def list_to_keyword_list([head | tail]), do: [{String.to_atom(head), list_to_keyword_list(tail)}]

  # Key exists in both maps, and both values are maps as well.
  # These can be merged recursively.
  defp deep_resolve(_key, left = %{}, right = %{}), do: deep_merge(left, right)

  # Key exists in both maps, but at least one of the values is
  # NOT a map. We fall back to standard merge behavior, preferring
  # the value on the right.
  defp deep_resolve(_key, _left, right), do: right
end
