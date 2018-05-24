defmodule QueryEngine.Parser.ApiParser do

  alias QueryEngine.Interface.Request

  alias QueryEngine.Query.Field
  alias QueryEngine.Query.Filter
  alias QueryEngine.Query.Order
  alias QueryEngine.Query.Association

  def parse("", schema), do: %Request{schema: schema}

  def parse(json, schema) when is_binary(json) do
    parsed_query = Poison.decode!(json)
    fields = 
      parsed_query
      |> parse_fields

    associations = load_associations(fields)
    fields = set_associations(fields, associations)

    do_parse(%Request{schema: schema, associations: associations}, parsed_query, fields)
  end

  defp parse_fields(query) do
    [
      do_parse_fields([], Enum.map(query["filters"] || [], &(&1["operand"]))),
      do_parse_fields([], Enum.map(query["order"] || [], &(&1["column"]))),
      do_parse_fields([], query["includes"] || [])
    ]
    |> List.flatten
    |> Enum.uniq
    |> Enum.map(&{Field.full_path(&1), &1})
  end

  defp load_associations(fields) do
    fields
    |> Enum.map(&elem(&1, 1).association_path)
    |> Enum.filter(&!is_nil(&1))
    |> Enum.map(&Association.from_path(&1))
    |> List.flatten
    |> Enum.uniq
    |> Association.assign_bindings
  end

  # Set the associations for all the fields if needed
  defp set_associations(fields, associations) do
    fields
    |> Enum.map(&{elem(&1, 0), Field.set_association(elem(&1, 1), associations)})
    |> Map.new
  end

  defp do_parse_fields(acc, []), do: acc
  defp do_parse_fields(acc, [field | tail]) do
    [Field.from_path(field) | acc]
    |> do_parse_fields(tail)
  end

  defp do_parse(request, %{"filters" => filters} = query, fields) do
    filters =
      filters
      |> Enum.map(&parse_filter(&1, fields))
      |> Enum.reverse

    %Request{request | filters: filters}
    |> do_parse(Map.delete(query, "filters"), fields)
  end

  defp do_parse(request, %{"order" => orders} = query, fields) do
    orders =
      orders
      |> Enum.map(&parse_order(&1, fields))
      |> Enum.reverse

    %Request{request | sorts: orders}
    |> do_parse(Map.delete(query, "order"), fields)
  end

  defp do_parse(request, %{"includes" => includes} = query, fields) do
    %Request{request | side_loads: includes}
    |> do_parse(Map.delete(query, "includes"), fields)
  end

  defp do_parse(request, %{"limit" => limit} = query, fields) do
    %Request{request | limit: limit}
    |> do_parse(Map.delete(query, "limit"), fields)
  end

  defp do_parse(request, %{"offset" => offset} = query, fields) do
    %Request{request | offset: offset}
    |> do_parse(Map.delete(query, "offset"), fields)
  end

  defp do_parse(request, %{}, _fields), do: request

  defp parse_filter(%{"operand" => operand, "operator" => operator, "value" => value}, fields) do
    %Filter{field: fields[operand], operator: String.to_atom(operator), value: value}
  end

  defp parse_order(%{"column" => column, "direction" => direction}, fields) do
    %Order{field: fields[column], direction: String.to_atom(direction)}
  end
end
