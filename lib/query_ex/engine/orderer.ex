defmodule QueryEx.Engine.Orderer do
  @moduledoc """
  Provides ordering capabilities to query with an optional association
  """
  import Ecto.Query
  alias QueryEx.Query.Order
  alias QueryEx.Query.Field

  @doc """
  Orders the result set by a field and direction

  ## Example:
  
      iex> field = QueryEx.Query.Field.from_path("last_name")
      iex> order = %QueryEx.Query.Order{field: field, direction: :asc}
      iex> QueryEx.Engine.Orderer.order(Dummy.Person, order)
      #Ecto.Query<from p in Dummy.Person, order_by: [asc: p.last_name]>
  """
  def order(query, %Order{field: query_field, direction: :asc}) do
    query
    |> order_by([m: Field.binding(query_field)], asc: field(m, ^query_field.column))
  end

  def order(query, %Order{field: query_field, direction: :desc}) do
    query
    |> order_by([m: Field.binding(query_field)], desc: field(m, ^query_field.column))
  end

end

