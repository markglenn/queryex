defmodule QueryEngine.Interface.Request do
  defstruct [:schema, :filters, :associations, :sorts, :side_loads]
end
