defmodule QueryEx.Query.Filter do
  @moduledoc """
  Defines a filter for a query
  """

  defstruct [:field, :operator, :value]
end
