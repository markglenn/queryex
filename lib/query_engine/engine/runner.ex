defmodule QueryEngine.Engine.Runner do
  alias QueryEngine.Interface.Request

  alias QueryEngine.Engine.Joiner
  alias QueryEngine.Engine.Filterer
  alias QueryEngine.Engine.Orderer
  alias QueryEngine.Engine.Preloader

  def run(%Request{schema: schema, filters: filters, associations: associations, sorts: sorts, side_loads: side_loads}) do
    schema
    |> join(associations)
    |> filter(filters)
    |> sort(sorts)
    |> side_load(side_loads)
    |> Dummy.Repo.all
  end

  defp join(query, [head | tail]) do
    query
    |> Joiner.join(head)
    |> join(tail)
  end
  defp join(query, _), do: query

  defp filter(query, [head | tail]) do
    query
    |> Filterer.filter(head)
    |> filter(tail)
  end
  defp filter(query, _), do: query

  defp sort(query, [head | tail]) do
    query
    |> Orderer.order(head)
    |> sort(tail)
  end
  defp sort(query, _), do: query

  defp side_load(query, [head | tail]) do
    query
    |> Preloader.preload_path(head)
    |> side_load(tail)
  end
  defp side_load(query, _), do: query
end
