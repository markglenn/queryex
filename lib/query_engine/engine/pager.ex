defmodule QueryEngine.Engine.Pager do
  import Ecto.Query

  alias QueryEngine.Query.Field

  def page(query, limit, offset, sorts \\ []) do
    query
    |> dense_rank(sorts, offset || 0)
    |> limit(^(limit || 100))
    |> offset(^(offset || 0))
  end

  defp dense_rank(query, nil, offset), do: dense_rank(query, [], offset)
  defp dense_rank(query, [], offset) do
    select_merge(
      query,
      [m: 0],
      %{ __count__: fragment("dense_rank() over (ORDER BY ? desc) + ? as __count__", field(m, ^primary_key(query)), ^offset) }
    )
  end

  defp dense_rank(query, [%{field: query_field, direction: :desc} | []], offset) do
    select_merge(
      query,
      [m: Field.binding(query_field)],
      %{ __count__: fragment("dense_rank() over (ORDER BY ? asc) + ? as __count__", field(m, ^query_field.column), ^offset) }
    )
  end
  
  defp dense_rank(query, [%{field: query_field, direction: :asc} | []], offset) do
    select_merge(
      query,
      [m: Field.binding(query_field)],
      %{ __count__: fragment("dense_rank() over (ORDER BY ? desc) + ? as __count__", field(m, ^query_field.column), ^offset) }
    )
  end

  defp dense_rank(query, [%{field: query_field, direction: :desc} | [%{field: other_field, direction: :desc}]], offset) do
    select_merge(
      query,
      [m: Field.binding(query_field), n: Field.binding(other_field)],
      %{ __count__: fragment("dense_rank() over (ORDER BY ? asc, ? asc) + ? as __count__", field(m, ^query_field.column), field(n, ^other_field.column), ^offset) }
    )
  end

  defp dense_rank(query, [%{field: query_field, direction: :asc} | [%{field: other_field, direction: :desc}]], offset) do
    select_merge(
      query,
      [m: Field.binding(query_field), n: Field.binding(other_field)],
      %{ __count__: fragment("dense_rank() over (ORDER BY ? desc, ? asc) + ? as __count__", field(m, ^query_field.column), field(n, ^other_field.column), ^offset) }
    )
  end

  defp dense_rank(query, [%{field: query_field, direction: :desc} | [%{field: other_field, direction: :asc}]], offset) do
    select_merge(
      query,
      [m: Field.binding(query_field), n: Field.binding(other_field)],
      %{ __count__: fragment("dense_rank() over (ORDER BY ? asc, ? desc) + ? as __count__", field(m, ^query_field.column), field(n, ^other_field.column), ^offset) }
    )
  end

  defp dense_rank(query, [%{field: query_field, direction: :asc} | [%{field: other_field, direction: :asc}]], offset) do
    select_merge(
      query,
      [m: Field.binding(query_field), n: Field.binding(other_field)],
      %{ __count__: fragment("dense_rank() over (ORDER BY ? desc, ? desc) + ? as __count__", field(m, ^query_field.column), field(n, ^other_field.column), ^offset) }
    )
  end

  defp query_module(%{from: {_table, module}}), do: module
  defp query_module(module), do: module

  defp primary_key(query), do: List.first(query_module(query).__schema__(:primary_key))
end
