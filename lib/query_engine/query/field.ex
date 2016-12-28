defmodule QueryEngine.Query.Field do
  @moduledoc """
  Contains the field information including the association
  """

  alias QueryEngine.Query.Path
  alias QueryEngine.Query.Field

  defstruct [:column, :association_path, :association]

  def from_path(path) do
    {column, association_path} = Path.parse(path)

    case column do
      nil -> %Field{column: nil, association_path: association_path}
      _   -> %Field{column: String.to_atom(column), association_path: association_path}
    end
  end

  def binding(%Field{association: nil}), do: 0
  def binding(%Field{association: association}), do: association.binding

  def set_association(field, associations) do
    association =
      associations
      |> Enum.find(fn(a) -> a.path == field.association_path end)

    %Field{field | association: association}
  end
end
