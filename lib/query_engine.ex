defmodule QueryEngine do
  @moduledoc """
  A sql query engine framework

  ```
  MyModels.User
    |> QueryEngine.from_schema
    |> QueryEngine.side_load("organization.country")
    |> QueryEngine.filter("name", :like, "John D%")
    |> QueryEngine.filter("organization.name", :=, "Test Organization")
    |> QueryEngine.order_by("inserted_at", :desc)
    |> QueryEngine.page(10, 20)
    |> QueryEngine.build
  ```
  """

  alias QueryEngine.Interface.Request
  alias QueryEngine.Query.Filter
  alias QueryEngine.Query.Order
  alias QueryEngine.Engine.Builder

  @doc """
  Creates a QueryEngine.Interface.Request with the given schema

  Returns: A request with the schema set

  ## Examples

      iex> QueryEngine.from_schema(MyModel)
      %QueryEngine.Interface.Request{schema: MyModel}

  """
  def from_schema(schema) do
    %Request{schema: schema}
  end

  @doc """

  Adds a filter to the request.  When called multiple times, the queries are
  combined with `AND`.

  Returns: A request with the given filter added to the filter list

  ## Examples

      iex> QueryEngine.from_schema(Dummy.Person) |> QueryEngine.filter("name", :like, "John %")
      %QueryEngine.Interface.Request{
        associations: nil,
        filters: [
          %QueryEngine.Query.Filter{field: "name", operator: :like, value: "John %"}
        ],
        limit: nil,
        offset: nil,
        schema: Dummy.Person,
        side_loads: nil,
        sorts: nil
      }

  """
  def filter(%Request{filters: nil} = request, field, operator, value) do
    %{request | filters: []}
    |> filter(field, operator, value)
  end

  def filter(%Request{filters: filters} = request, field, operator, value) do
    %{request | filters: [%Filter{field: field, operator: operator, value: value} | filters]}
  end

  @doc """

  Adds a request to sideload data.

  Returns: A request with the given table added to the side load list

  ## Examples

      iex> QueryEngine.from_schema(Dummy.Person) |> QueryEngine.side_load("company.employees")
      %QueryEngine.Interface.Request{
        associations: nil,
        filters: nil,
        limit: nil,
        offset: nil,
        schema: Dummy.Person,
        side_loads: ["company.employees"],
        sorts: nil
      }

  """
  def side_load(%Request{side_loads: nil} = request, side_load), do: side_load(%Request{request | side_loads: []}, side_load)
  def side_load(%Request{side_loads: side_loads} = request, side_load) do
    %{request | side_loads: [side_load | side_loads]}
  end

  @doc """

  Adds an ORDER BY operation to the request

  Returns: A request with the given sort added to the sorts

  ## Examples

      iex> QueryEngine.from_schema(Dummy.Person) |> QueryEngine.order_by("inserted_at", :desc)
      %QueryEngine.Interface.Request{
        associations: nil,
        filters: nil,
        limit: nil,
        offset: nil,
        schema: Dummy.Person,
        side_loads: nil,
        sorts: [%QueryEngine.Query.Order{direction: :desc, field: "inserted_at"}]
      }

  """
  def order_by(%Request{sorts: nil} = request, field, direction), do: order_by(%{request | sorts: []}, field, direction)
  def order_by(%Request{sorts: sorts} = request, field, direction) do
    %{request | sorts: [%Order{field: field, direction: direction} | sorts]}
  end

  @doc """

  Paginates the result set

  Returns: A request with the pagination parameters set

  ## Examples

      iex> QueryEngine.from_schema(Dummy.Person) |> QueryEngine.page(100, 10)
      %QueryEngine.Interface.Request{
        associations: nil,
        filters: nil,
        limit: 100,
        offset: 10,
        schema: Dummy.Person,
        side_loads: nil,
        sorts: nil
      }

  """
  def page(%Request{} = request, limit, offset), do: %{request | limit: limit, offset: offset}

  @doc """

  Builds the final query to be run with Ecto

  Returns: An `Ecto.Query` that handles all the information from the request

  ## Examples

      iex> QueryEngine.from_schema(Dummy.Person) |> QueryEngine.filter("name", :like, "John %") |> QueryEngine.build
      #Ecto.Query<from p in Dummy.Person, where: like(p.name, ^"John %"), order_by: [asc: p.id], limit: ^100, offset: ^0, select: {p, fragment("count(1) OVER() AS __count__")}>

  """
  def build(%Request{} = request), do: Builder.build(request)
end
