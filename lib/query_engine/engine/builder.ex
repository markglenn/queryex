defmodule QueryEngine.Engine.Builder do
  alias QueryEngine.Interface.Request

  alias QueryEngine.Engine.Filterer
  alias QueryEngine.Engine.Joiner
  alias QueryEngine.Engine.Orderer
  alias QueryEngine.Engine.Pager
  alias QueryEngine.Engine.Preloader

  alias QueryEngine.Query.Field
  alias QueryEngine.Query.Order

  def build(%Request{sorts: nil} = request), do: build(%{request | sorts: []})
  def build(%Request{sorts: []} = request), do: build(%{request | sorts: [%Order{field: "id", direction: :asc}]})
  def build(%Request{associations: nil} = request) do
    request
    |> Request.set_associations
    |> do_build
  end

  defp do_build(%Request{} = request) do
    request.schema
    |> join(request.associations)
    |> filter(request.filters)
    |> sort(request.sorts)
    |> side_load(request.side_loads)
    |> Pager.page(request.limit, request.offset)
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
