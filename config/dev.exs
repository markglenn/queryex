use Mix.Config

# Configure your database
config :query_engine, QueryEngine.Support.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "query_engine_dev",
  hostname: "localhost",
  pool_size: 10
