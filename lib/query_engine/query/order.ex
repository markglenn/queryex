defmodule QueryEngine.Query.Order do
  @moduledoc """
  Defines the field and direction for an order clause in a query
  """
  defstruct [:field, :direction]
end
