defmodule QueryEngine.Engine.Pager do
  @moduledoc """
  Defines the functionality to add paging to the result set.  When used, the
  results will include a `__count__` property on all results that equates to
  the number of results found
  """

  import Ecto.Query

  @doc """
  Pages the result set and includes a count
  
  ### Example

      iex> QueryEngine.Engine.Pager.page(Dummy.Person, 30, 10)
      #Ecto.Query<from p in Dummy.Person, limit: ^30, offset: ^10, select: {p, fragment("count(1) OVER() AS __count__")}>

  """
  def page(query, limit, offset) do
    query
    |> include_count
    |> limit(^(limit || 100))
    |> offset(^(offset || 0))
  end

  defp include_count(query) do
    query
    |> select([m: 0], {m, fragment("count(1) OVER() AS __count__")})
  end
end
