defmodule QueryEngine.Query.Association do
  defstruct [:name, :binding, :parent]
  alias QueryEngine.Query.Association

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

