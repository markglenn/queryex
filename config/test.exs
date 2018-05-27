use Mix.Config

config :queryex,
  ecto_repos: [Dummy.Repo]

config :logger, level: :warn

# Configure your database
config :queryex, Dummy.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "query_ex_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
