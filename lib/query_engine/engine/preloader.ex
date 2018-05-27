defmodule QueryEngine.Engine.Preloader do
  @moduledoc """
  Helps preload request associations
  """

  import Ecto.Query
  alias QueryEngine.Query.Association

  @doc """
  Preloads a path

      iex> QueryEngine.Engine.Preloader.preload_path(Dummy.Person, "organization.country")
      #Ecto.Query<from p in Dummy.Person, preload: [[organization: :country]]>
  """
  def preload_path(query, path) do
    preload_path =
      Association.from_side_loads([path])

    query
    |> preload(^preload_path)
  end
end
