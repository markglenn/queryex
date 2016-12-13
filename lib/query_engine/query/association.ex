defmodule QueryEngine.Query.Association do
  defstruct [:name, :binding, :parent, :path]

  alias QueryEngine.Query.Association

  def parse_path(path) do
    path
    |> String.split(".")
    |> Enum.map(&(%Association{name: &1}))
    |> Enum.reduce([], fn(a, acc) -> [%Association{a | parent: Enum.at(acc, 0)} | acc] end)
    |> Enum.map(&(%Association{&1 | path: Association.path(&1)}))
    |> Enum.reverse
    |> Enum.reduce([], fn(a, acc) -> [%Association{a | parent: Enum.at(acc, 0)} | acc] end)
    |> Enum.reverse
  end

  # Return the full path of the association
  def path(association) do
    do_path(association)
    |> Enum.reverse
    |> Enum.join(".")
  end

  defp do_path(%Association{name: name, parent: nil}), do: [name]
  defp do_path(%Association{name: name, parent: parent}) do
    [name | do_path(parent)]
  end
end
