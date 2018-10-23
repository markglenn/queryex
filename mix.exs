defmodule QueryEx.Mixfile do
  use Mix.Project

  def project do
    [app: :queryex,
     version: "0.1.0",
     elixir: "~> 1.6",
     deps: deps(),
     elixirc_paths: elixirc_paths(Mix.env),
     package: package(),
     aliases: aliases(),
     name: "QueryEx",
     source_url: "https://github.com/markglenn/queryex"
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :ecto]]
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
     {:postgrex, ">= 0.0.0", only: [:test]},
     {:ex_machina, "~> 2.2", only: [:test]},
     {:credo, "~> 0.9.1", only: [:dev, :test], runtime: false},
     {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end

  defp package do
    [contributors: ["Mark Glenn"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/markglenn/queryex"}]
  end

  defp aliases do
    [test: ["ecto.create --quiet", "ecto.migrate", "test"]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/dummy", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
