defmodule QueryEngine.Engine.Joiner do
  import Ecto.Query
  alias QueryEngine.Query.Association

  def join(query, association) do
    query
    |> join(:inner, [m: association.parent_binding], c in assoc(m, ^Association.name(association)))
  end
end
