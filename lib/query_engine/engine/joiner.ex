defmodule QueryEngine.Engine.Joiner do
  import Ecto.Query

  def join(query, association) do
    query
    |> join(:inner, [p], c in assoc(p, ^association.name))
  end
end
