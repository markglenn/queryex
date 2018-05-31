defmodule QueryEx.Engine.Joiner do
  @moduledoc """
  Provides ability to join an association to a base query
  """
  import Ecto.Query
  alias QueryEx.Query.Association

  @doc """
  Joins a parent table to it's child using the given bindings

      iex> association = %QueryEx.Query.Association{path: "organization", binding: 1, parent_binding: 0}
      iex> Dummy.Person
      ...> |> QueryEx.Engine.Joiner.join(association)
      #Ecto.Query<from p in Dummy.Person, join: o in assoc(p, :organization)>

  """
  def join(query, association) do
    query
    |> join(:inner, [m: association.parent_binding], c in assoc(m, ^Association.name(association)))
  end
end
