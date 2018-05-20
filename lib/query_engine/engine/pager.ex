defmodule QueryEngine.Engine.Pager do
  import Ecto.Query

  def page(query, limit, offset) do
    query
    |> dense_rank
    |> limit(^(limit || 100))
    |> offset(^(offset || 0))
  end

  defp dense_rank(query) do
    query
    |> select([m: 0], {m, fragment("count(*) OVER() AS __count__")})
  end
end
