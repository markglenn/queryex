defmodule QueryEngine do
  @moduledoc """
  QueryEngine application

  MyModels.User
    |> QueryEngine.from_schema
    |> QueryEngine.side_load("organization.country")
    |> QueryEngine.filter("name", :like, "John D%")
    |> QueryEngine.filter("organization.name", :=, "Test Organization")
    |> QueryEngine.order_by("organization.name", :desc)
    |> QueryEngine.page(10, 20)
    |> QueryEngine.build
  """

  alias QueryEngine.Interface.Request
  alias QueryEngine.Query.Filter
  alias QueryEngine.Query.Order
  alias QueryEngine.Engine.Builder

  def from_schema(schema) do
    %Request{schema: schema}
  end

  def side_load(%Request{side_loads: nil} = request, side_load), do: side_load(%Request{request | side_loads: []}, side_load)
  def side_load(%Request{side_loads: side_loads} = request, side_load) do
    %{request | side_loads: [side_load | side_loads]}
  end

  def filter(%Request{filters: nil} = request, field, operator, value) do
    %{request | filters: []}
    |> filter(field, operator, value)
  end

  def filter(%Request{filters: filters} = request, field, operator, value) do
    %{request | filters: [%Filter{field: field, operator: operator, value: value} | filters]}
  end

  def order_by(%Request{sorts: nil} = request, field, direction), do: order_by(%{request | sorts: []}, field, direction)
  def order_by(%Request{sorts: sorts} = request, field, direction) do
    %{request | sorts: [%Order{field: field, direction: direction} | sorts]}
  end

  def page(%Request{} = request, limit, offset), do: %{request | limit: limit, offset: offset}

  def build(%Request{} = request), do: Builder.build(request)
end
