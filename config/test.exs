use Mix.Config

config :query_engine,
  ecto_repos: [Dummy.Repo]

config :logger, level: :warn

# Configure your database
config :query_engine, Dummy.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "query_engine_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
