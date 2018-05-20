defmodule QueryEngine.Engine.Runner do
  alias QueryEngine.Interface.Request

  alias QueryEngine.Engine.Filterer
  alias QueryEngine.Engine.Joiner
  alias QueryEngine.Engine.Orderer
  alias QueryEngine.Engine.Pager
  alias QueryEngine.Engine.Preloader

  alias QueryEngine.Query.Field
  alias QueryEngine.Query.Order

  def run(%Request{schema: schema, filters: filters, associations: associations, sorts: sorts, side_loads: side_loads, limit: limit, offset: offset}) do
    sorts = default_sort(sorts)

    schema
    |> join(associations)
    |> filter(filters)
    |> sort(sorts)
    |> side_load(side_loads)
    |> Pager.page(limit, offset, sorts)
  end

  defp default_sort([]), do: [%Order{field: %Field{column: :id}, direction: :asc}]
  defp default_sort(list), do: list

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
