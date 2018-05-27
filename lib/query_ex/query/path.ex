defmodule QueryEx.Query.Path do
  @moduledoc """
  Provides parsing options for paths
  """

  @doc """
  Parse a path into a field and its association path
  """
  def parse(path) do
    path
    |> String.split(".")
    |> Enum.reverse
    |> get_field_and_path
  end

  defp get_field_and_path([]), do: {nil, nil}
  defp get_field_and_path([field | []]), do: {field, nil}
  defp get_field_and_path([field | tail]) do
    path =
      tail
      |> Enum.reverse
      |> Enum.join(".")

    {field, path}
  end
end
