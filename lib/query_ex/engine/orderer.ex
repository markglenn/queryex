defmodule QueryEx.Engine.Orderer do
  @moduledoc """
  Provides ordering capabilities to query with an optional association
  """
  import Ecto.Query
  alias QueryEx.Query.Order
  alias QueryEx.Query.Field

  def order(query, %Order{field: query_field, direction: :asc}) do
    query
    |> order_by([m: Field.binding(query_field)], asc: field(m, ^query_field.column))
  end

  def order(query, %Order{field: query_field, direction: :desc}) do
    query
    |> order_by([m: Field.binding(query_field)], desc: field(m, ^query_field.column))
  end

end

