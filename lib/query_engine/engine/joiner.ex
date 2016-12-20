defmodule QueryEngine.Engine.Joiner do
  import Ecto.Query

  defmacro join(query, association, index) do
    quote do
      unquote(query)
      |> join(
        :inner,
        [t1, t2, t3],
        c in assoc(unquote("t#{1}"), ^unquote(association).name)
      )
    end
  end
end
