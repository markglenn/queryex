defmodule QueryEngine.Query.Path do
  def parse(path) do
    path
    |> String.split(".")
    |> Enum.reverse
    |> get_column_and_path
  end

  defp get_column_and_path([]), do: { nil, nil }
  defp get_column_and_path([column | []]), do: { column, nil }
  defp get_column_and_path([column | tail]) do
    path =
      tail
      |> Enum.reverse
      |> Enum.join(".")

    { column, path }
  end

end
