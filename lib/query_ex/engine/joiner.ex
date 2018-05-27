defmodule QueryEx.Engine.Joiner do
  @moduledoc """
  Provides ability to join an association to a base query
  """
  import Ecto.Query
  alias QueryEx.Query.Association

  def join(query, association) do
    query
    |> join(:inner, [m: association.parent_binding], c in assoc(m, ^Association.name(association)))
  end
end
