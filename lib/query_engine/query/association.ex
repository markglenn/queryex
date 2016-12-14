defmodule QueryEngine.Query.Association do
  defstruct [:name, :binding, :path]

  alias QueryEngine.Query.Association

  def parse_path(path) do
    path
    |> String.split(".")
    |> Enum.reduce({[], []}, fn(p, acc) ->
      # Current path list
      paths = [p | elem(acc, 1)]

      # Generate the full path from the accumulator's path list
      full_path =
        paths
        |> Enum.reverse
        |> Enum.join(".")

      association = %Association{name: p, path: full_path}
      {[association | elem(acc, 0)], paths}
    end)
    |> elem(0)
    |> Enum.reverse
  end
end
