defmodule QueryEngine.Query.Field do
  alias QueryEngine.Query.Path
  alias QueryEngine.Query.Field

  defstruct [:field, :association_path, :association]

  def from_path(path) do
    {field, association_path} = Path.parse(path)

    %Field{field: field, association_path: association_path}
  end

  def set_association(field, associations) do
    association =
      associations
      |> Enum.find(fn(a) -> a.path == field.association_path end)

    %Field{field | association: association}
  end
end
