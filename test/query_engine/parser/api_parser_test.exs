defmodule QueryEngine.Parser.ApiParserTest do
  use ExUnit.Case, async: true

  alias QueryEngine.Parser.ApiParser
  alias QueryEngine.Query.Filter
  alias QueryEngine.Query.Field
  alias QueryEngine.Query.Order

  test "Parses blank request" do
    ApiParser.parse("")
  end

  test "Parses filters" do
    query =
      %{
        orders: [%{column: "name", direction: "asc"}],
        filters: [%{operand: "organization.name", operator: "=", value: "Test"}]
      }
      |> Poison.encode!
      |> ApiParser.parse

    assert %{filters: [%Filter{value: "Test", operator: "="}]} = query
    assert %{filters: [%Filter{field: %Field{association_path: "organization", column: :name}}]} = query

    assert %{orders: [%Order{direction: "asc"}]} = query
    assert %{orders: [%Order{field: %Field{association_path: nil, column: :name}}]} = query
  end

end
