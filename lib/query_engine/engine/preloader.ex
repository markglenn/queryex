defmodule QueryEngine.Engine.Preloader do
  import Ecto.Query

  alias QueryEngine.Utils.MapUtils

  def preload_path(query, path) do
    preload_path =
      String.split(path, ".")
      |> MapUtils.list_to_keyword_list

    query
    |> preload(^preload_path)
  end
end
