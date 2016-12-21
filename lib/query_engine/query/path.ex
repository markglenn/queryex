defmodule QueryEngine.Query.Path do
  def parse(path) do
    path
    |> String.split(".")
    |> Enum.reverse
    |> get_field_and_path
  end

  defp get_field_and_path([]), do: { nil, nil }
  defp get_field_and_path([field | []]), do: { field, nil }
  defp get_field_and_path([field | tail]) do
    path =
      tail
      |> Enum.reverse
      |> Enum.join(".")

    { field, path }
  end
end
