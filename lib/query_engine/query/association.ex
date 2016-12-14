defmodule QueryEngine.Query.Association do
  defstruct [:name, :binding, :path]

  alias QueryEngine.Query.Association

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

      association = %Association{name: path_piece, path: full_path}
      {[association | elem(acc, 0)], paths}
    end)
    |> elem(0) # Only care about the association list, not the temporary path accumulator
    |> Enum.reverse
  end
end
