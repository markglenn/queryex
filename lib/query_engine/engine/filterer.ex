defmodule QueryEngine.Engine.Filterer do
  import Ecto.Query
  alias QueryEngine.Query.Filter
  alias QueryEngine.Query.Field

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
