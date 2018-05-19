defmodule QueryEngine.Interface.Request do
  defstruct [:filters, :joins, :orders, :includes]
end
