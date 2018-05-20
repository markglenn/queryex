defmodule QueryEngine.Engine.Pager do
  import Ecto.Query

  def page(query, limit, offset) do
    query
    |> include_count
    |> limit(^(limit || 100))
    |> offset(^(offset || 0))
  end

  defp include_count(query) do
    query
    |> select([m: 0], {m, fragment("count(*) OVER() AS __count__")})
  end
end
