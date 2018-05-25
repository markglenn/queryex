# QueryEngine

A SQL query engine framework for building APIs in Elixir.  Allows generating an
Ecto query using dynamic query parameters.

## Example

```
MyModels.User
  |> QueryEngine.from_schema
  |> QueryEngine.side_load("organization.country")
  |> QueryEngine.filter("name", :like, "John D%")
  |> QueryEngine.filter("organization.name", :=, "Test Organization")
  |> QueryEngine.order_by("inserted_at", :desc)
  |> QueryEngine.page(10, 20)
  |> QueryEngine.build
  |> MyApp.Repo.all
```
