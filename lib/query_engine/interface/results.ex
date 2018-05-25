defmodule QueryEngine.Interface.Results do
  defstruct [:data, :included]

  alias QueryEngine.Query.Association

  def build(results, []), do: %QueryEngine.Interface.Results{data: results}
  def build(results, side_loads) do
    %QueryEngine.Interface.Results{
      data: results,
      included: load_side_loads(results, side_loads)
    }
  end

  defp load_side_loads(results, side_loads) do
    side_loads
    |> Association.from_side_loads
    |> Enum.map(&side_load(results, &1))
    |> List.flatten
    |> Enum.uniq_by(fn result ->
      primary_key_values =
        result.__struct__.__schema__(:primary_key)
        |> Enum.map(&Map.get(result, &1))
        |> List.to_tuple
      
      {result.__struct__, primary_key_values}
    end)
  end

  defp side_load(results, {column, associations}) do
    results =
      results
      |> side_load(column)

    results ++ side_load(results, associations)
  end

  defp side_load(results, column) when is_atom(column) do
    results
    |> Enum.map(&Map.get(&1, column))
  end
end
