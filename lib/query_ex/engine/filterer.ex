defmodule QueryEx.Engine.Filterer do
  @moduledoc """
  Provides filter capabilities to query with an optional association
  """
  import Ecto.Query
  alias QueryEx.Query.Filter
  alias QueryEx.Query.Field

  @doc """

  Adds a filter with optional binding to the query

  ### Example

      iex> filter = %QueryEx.Query.Filter{
      ...>   field: QueryEx.Query.Field.from_path("first_name"),
      ...>   operator: :=,
      ...>   value: "John"
      ...> }
      iex> QueryEx.Engine.Filterer.filter(Dummy.Person, filter)
      #Ecto.Query<from p in Dummy.Person, where: p.first_name == ^"John">

  """
  def filter(query, %Filter{field: query_field, operator: :=, value: nil}) do
    query
    |> where([m: Field.binding(query_field)], is_nil(field(m, ^query_field.column)))
  end

  def filter(query, %Filter{field: query_field, operator: :!=, value: nil}) do
    query
    |> where([m: Field.binding(query_field)], not is_nil(field(m, ^query_field.column)))
  end

  def filter(query, %Filter{field: query_field, operator: :=, value: value}) do
    query
    |> where([m: Field.binding(query_field)], field(m, ^query_field.column) == ^value)
  end

  def filter(query, %Filter{field: query_field, operator: :!=, value: value}) do
    query
    |> where([m: Field.binding(query_field)], field(m, ^query_field.column) != ^value)
  end

  def filter(query, %Filter{field: query_field, operator: :>, value: value}) do
    query
    |> where([m: Field.binding(query_field)], field(m, ^query_field.column) > ^value)
  end

  def filter(query, %Filter{field: query_field, operator: :<, value: value}) do
    query
    |> where([m: Field.binding(query_field)], field(m, ^query_field.column) < ^value)
  end

  def filter(query, %Filter{field: query_field, operator: :>=, value: value}) do
    query
    |> where([m: Field.binding(query_field)], field(m, ^query_field.column) >= ^value)
  end

  def filter(query, %Filter{field: query_field, operator: :<=, value: value}) do
    query
    |> where([m: Field.binding(query_field)], field(m, ^query_field.column) <= ^value)
  end

  def filter(query, %Filter{field: query_field, operator: :like, value: value}) do
    query
    |> where([m: Field.binding(query_field)], like(field(m, ^query_field.column), ^value))
  end

  def filter(query, %Filter{field: query_field, operator: :not_like, value: value}) do
    query
    |> where([m: Field.binding(query_field)], not like(field(m, ^query_field.column), ^value))
  end
end
