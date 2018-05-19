defmodule QueryEngine.Query.Association do
  @moduledoc """
  Provides association information between two schemas
  """

  defstruct [:path, :binding, :parent_binding]

  alias QueryEngine.Query.Association
  alias QueryEngine.Query.Path

  @doc """
  Retrieves the name of the association from the full path
  """
  def name(%Association{path: ""}), do: nil
  def name(%Association{path: path}) do
    {name, _} = Path.parse(path)

    String.to_atom(name)
  end

  @doc """
  Generates a list of associations from a path
  """
  def from_path(path) do
    path
    |> String.split(".")
    |> Enum.reduce({[], []}, fn(path_piece, acc) ->
      # acc is defined as {association_list, parent_path_list}

      # Current path list
      paths = [path_piece | elem(acc, 1)]

      # Generate the full path from the accumulator's path list
      full_path =
        paths
        |> Enum.reverse
        |> Enum.join(".")

      association = %Association{path: full_path}
      {[association | elem(acc, 0)], paths}
    end)
    |> elem(0) # Only care about the association list, not the temporary path accumulator
    |> Enum.reverse
  end

  def from_side_loads(side_loads) do
    side_loads
    |> Enum.reverse
    |> Enum.map(&String.split(&1, "."))
    |> Enum.reduce([], fn(x, acc) ->
      x
      |> to_side_load_list
      |> Keyword.merge(acc, &merge_keywords/3)
    end)
    |> Enum.map(&clean_side_load(&1))
  end

  @doc """
  Assigns binding keys to associations based on their order
  """
  def assign_bindings(associations) do
    associations
    |> Enum.uniq_by(fn(a) -> a.path end)
    |> Enum.with_index()
    |> Enum.map(fn({association, index}) -> %Association{association | binding: index + 1} end)
    |> set_parent_bindings
  end

  defp set_parent_bindings(associations) do
    Enum.map(associations, fn(association) ->
      {_, parent_path} = Path.parse(association.path)

      parent_association =
        associations
        |> Enum.find(fn(a) -> a.path == parent_path end)

      case parent_association do
        nil ->
          %Association{association | parent_binding: 0}
        _ ->
          %Association{association | parent_binding: parent_association.binding}
      end
    end)
  end

  defp to_side_load_list([]), do: []
  defp to_side_load_list([head | []]), do: [{String.to_atom(head), nil}]
  defp to_side_load_list([head | tail]), do: [{String.to_atom(head), to_side_load_list(tail)}]

  defp clean_side_load({left, nil}), do: left
  defp clean_side_load({left, [{right, nil}]}), do: {left, right}
  defp clean_side_load({left, right}) when is_list(right), do: {left, clean_side_load(right)}

  defp merge_keywords(_k, left, right) when is_list(left) and is_list(right) do
    left + right
  end

  defp merge_keywords(_k, nil, nil), do: nil
  defp merge_keywords(_k, left, nil), do: left
  defp merge_keywords(_k, nil, right), do: right
end
