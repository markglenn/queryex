defmodule QueryEngine.Query.Association do
  defstruct [:path, :binding, :parent_binding]

  alias QueryEngine.Query.Association

  def name(%Association{path: ""}), do: nil
  def name(%Association{path: path}) do
    path
    |> String.split(".")
    |> Enum.at(-1)
    |> String.to_atom
  end

  def parse_path(path) do
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

  def assign_bindings(associations) do
    associations
    |> Enum.uniq_by(fn(a) -> a.path end)
    |> Enum.with_index()
    |> Enum.map(fn({association, index}) -> %Association{association | binding: index + 1} end)
    |> set_parent_bindings
  end

  defp set_parent_bindings(associations) do
    Enum.map(associations, fn(association) ->
      parent_path =
        association.path
        |> String.split(".")
        |> Enum.drop(-1)
        |> Enum.join(".")

      parent_association =
        associations
        |> Enum.find(fn(possible_parent) -> possible_parent.path == parent_path end)

      case parent_association do
        nil ->
          %Association{association | parent_binding: 0}
        _ ->
          %Association{association | parent_binding: parent_association.binding}
      end
    end)
  end
end
