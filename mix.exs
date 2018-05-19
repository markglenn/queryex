defmodule QueryEngine.Mixfile do
  use Mix.Project

  def project do
    [app: :query_engine,
     version: "0.1.0",
     elixir: "~> 1.6",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     aliases: aliases()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :ecto, :postgrex, :ex_machina],
     mod: {QueryEngine, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ecto, "~> 2.2"},
     {:postgrex, ">= 0.0.0"},
     {:ex_machina, "~> 2.2", only: [:test]},
     {:credo, "~> 0.9.1", only: [:dev, :test], runtime: false},
    ]
  end

  defp aliases do
    ["test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end

  defp elixirc_paths(:prod), do: ["lib"]
  defp elixirc_paths(_),     do: ["lib", "test/dummy", "test/support"]
end
