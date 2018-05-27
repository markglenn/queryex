defmodule QueryEx.Interface.Request do
  @moduledoc """

  Defines a request to the query engine.
  
  See also `QueryEx`

  """

  defstruct [:schema, :filters, :associations, :sorts, :side_loads, :limit, :offset]

  alias QueryEx.Interface.Request
  alias QueryEx.Query.Association
  alias QueryEx.Query.Field

  def set_associations(%Request{} = request) do
    fields = load_fields(request)
    associations = load_associations(fields)
    fields = set_associations(fields, associations)

    request
      |> update_filter_fields(fields)
      |> update_sort_fields(fields)
      |> Map.put(:associations, associations)
  end

  defp load_fields(%Request{filters: filters, sorts: sorts, side_loads: side_loads}) do
    [
      get_fields(filters),
      get_fields(sorts),
      side_loads || []
    ]
    |> List.flatten
    |> Enum.uniq
    |> Enum.map(&Field.from_path/1)
    |> Enum.map(&{Field.full_path(&1), &1})
  end

  defp get_fields(fields) do
    fields
    |> do_get_fields
    |> Enum.reverse
  end

  defp do_get_fields(nil), do: []
  defp do_get_fields([]), do: []
  defp do_get_fields([%{field: %{column: column}} | tail]) do
    [column | get_fields(tail)]
  end
  defp do_get_fields([%{field: column} | tail]) do
    [column | get_fields(tail)]
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
  #
  # Set the associations for all the fields if needed
  defp set_associations(fields, associations) do
    fields
    |> Enum.map(&{elem(&1, 0), Field.set_association(elem(&1, 1), associations)})
    |> Map.new
  end

  defp update_filter_fields(%Request{filters: filters} = request, fields) do
    filters =
      filters
      |> do_update_associations(fields, [])
      |> Enum.reverse

    %{request | filters: filters}
  end

  defp update_sort_fields(%Request{sorts: sorts} = request, fields) do
    sorts =
      sorts
      |> do_update_associations(fields, [])
      |> Enum.reverse

    %{request | sorts: sorts}
  end

  defp do_update_associations(nil, _fields, acc), do: acc
  defp do_update_associations([], _fields, acc), do: acc
  defp do_update_associations([head | tail], fields, acc) do
    do_update_associations(tail, fields, [%{head | field: fields[head.field]} | acc])
  end
end
