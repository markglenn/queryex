defmodule QueryEngine.Engine.Preloader do
  import Ecto.Query
  alias QueryEngine.Query.Association

  def preload_path(query, path) do
    preload_path =
      Association.from_side_loads([path])

    query
    |> preload(^preload_path)
  end
end
