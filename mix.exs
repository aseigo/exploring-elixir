defmodule ExploringElixir.Mixfile do
  use Mix.Project

  def project do
    [app: :exploring_elixir,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ExploringElixir.Application, []}
    ]
  end

  defp deps do
    [
      {:benchee, "~> 0.9.0"},
      {:benchee_html, "~> 0.3"},
      {:ecto, "~> 2.1.4"},
      {:flow, "~> 0.11" },
      {:poison, "~> 3.1.0"},
      {:postgrex, "~> 0.13.3"},
      {:timex, "~> 3.0"},
      {:triplex, "~> 0.9.0"},
      {:uuid, "~> 1.1.7"},

      # dev and test dependencies
      {:quixir, "~>0.9", only: :test},
      {:remix, "~> 0.0.2", only: [:dev, :test]},
      {:credo, "~> 0.8.1", only: [:dev, :test]}
    ]
  end
end
