defmodule QueryEngine.Engine.Builder do
  @moduledoc """

  Builds an `Ecto.Query` from a `QueryEngine.Interface.Request`

  Takes a fully formed `QueryEngine.Interface.Request` and dynamically
  generates an Ecto.Query which can be directly executed using Repo.all

  """
  alias QueryEngine.Interface.Request

  alias QueryEngine.Engine.Filterer
  alias QueryEngine.Engine.Joiner
  alias QueryEngine.Engine.Orderer
  alias QueryEngine.Engine.Pager
  alias QueryEngine.Engine.Preloader

  alias QueryEngine.Query.Order

  @doc """

  Takes the `QueryEngine.Interface.Request` and returns an `Ecto.Query`

  Important: If no sort order is given, it defaults to sorting by the primary key

  ## Example

  iex> request = %QueryEngine.Interface.Request{schema: Dummy.Person, limit: 100, offset: 0}
  iex> QueryEngine.Engine.Builder.build(request)
  #Ecto.Query<from p in Dummy.Person, order_by: [asc: p.id], limit: ^100, offset: ^0, select: {p, fragment("count(1) OVER() AS __count__")}>

  """
  def build(%Request{sorts: nil} = request), do: build(%{request | sorts: []})
  def build(%Request{sorts: [], schema: schema} = request) do
    # Default to sorting by the primary key(s) ascending
    sorts =
      schema.__schema__(:primary_key)
      |> Enum.map(&Atom.to_string/1)
      |> Enum.map(&(%Order{field: &1, direction: :asc}))

    build %{request | sorts: sorts}
  end

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
