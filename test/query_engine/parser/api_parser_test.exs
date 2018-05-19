defmodule QueryEngine.Parser.ApiParserTest do
  use ExUnit.Case, async: true

  alias QueryEngine.Parser.ApiParser
  alias QueryEngine.Interface.Request
  alias QueryEngine.Query.Filter
  alias QueryEngine.Query.Field
  alias QueryEngine.Query.Order

  test "Parses blank request" do
    assert ApiParser.parse("", Dummy.Person) == %Request{schema: Dummy.Person}
  end

  test "Parses filters" do
    query =
      %{
        order: [%{column: "name", direction: "asc"}],
        filters: [%{operand: "organization.name", operator: "=", value: "Test"}]
      }
      |> Poison.encode!
      |> ApiParser.parse(Dummy.Person)

    assert %Request{filters: [%Filter{value: "Test", operator: :=}]} = query
    assert %Request{filters: [%Filter{field: %Field{association_path: "organization", column: :name}}]} = query

    assert %Request{sorts: [%Order{direction: :asc}]} = query
    assert %Request{sorts: [%Order{field: %Field{association_path: nil, column: :name}}]} = query
  end

end
