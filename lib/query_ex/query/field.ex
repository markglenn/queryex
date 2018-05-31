defmodule QueryEx.Query.Field do
  @moduledoc """
  Contains the field information including the association
  """

  alias QueryEx.Query.Path
  alias QueryEx.Query.Field

  defstruct [:column, :association_path, :association]

  @doc """
  Creates a field from a given path.  Splits the association path and the column name

      iex> QueryEx.Query.Field.from_path("organization.name")
      %QueryEx.Query.Field{
        association: nil,
        association_path: "organization",
        column: :name
      }
  """
  def from_path(path) do
    {column, association_path} = Path.parse(path)

    case column do
      nil -> %Field{column: nil, association_path: association_path}
      _   -> %Field{column: String.to_atom(column), association_path: association_path}
    end
  end

  @doc """
  Rebuilds the full path for a column, combining the association path and column.

      iex> field = %QueryEx.Query.Field{
      ...>  association: nil,
      ...>  association_path: "organization",
      ...>  column: :name
      ...>}
      iex> QueryEx.Query.Field.full_path(field)
      "organization.name"
  """
  def full_path(%Field{column: column, association_path: nil}), do: Atom.to_string(column)
  def full_path(%Field{column: column, association_path: path}) do
    "#{path}.#{Atom.to_string(column)}"
  end

  @doc """
  Returns the table binding number from the fields association

      iex> association = %QueryEx.Query.Association{path: "organizations", binding: 1}
      iex> %QueryEx.Query.Field{
      ...>  association: association,
      ...>  association_path: "organization",
      ...>  column: :name
      ...>} |> QueryEx.Query.Field.binding
      1
  """
  def binding(%Field{association: nil}), do: 0
  def binding(%Field{association: association}), do: association.binding

  @doc """
  Sets the association based on the association path

      iex> association = %QueryEx.Query.Association{path: "organization", binding: 1}
      iex> %QueryEx.Query.Field{
      ...>  association: nil,
      ...>  association_path: "organization",
      ...>  column: :name
      ...>} |> QueryEx.Query.Field.set_association([association])
      %QueryEx.Query.Field{
             association: %QueryEx.Query.Association{
               binding: 1,
               parent_binding: nil,
               path: "organization"
             },
             association_path: "organization",
             column: :name
           }
  """
  def set_association(field, associations) do
    association =
      associations
      |> Enum.find(fn(a) -> a.path == field.association_path end)

    %Field{field | association: association}
  end
end
