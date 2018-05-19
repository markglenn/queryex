defmodule QueryEngine.Engine.Preloader do
  import Ecto.Query
  alias QueryEngine.Query.Association

  def preload_path(query, path) do
    preload_path =
      Association.from_side_loads([path])

    query
    |> preload(^preload_path)
  end

  defp list_to_keyword_list([]), do: nil
  defp list_to_keyword_list([head | []]), do: String.to_atom(head)
  defp list_to_keyword_list([head | tail]), do: [{String.to_atom(head), list_to_keyword_list(tail)}]
end
