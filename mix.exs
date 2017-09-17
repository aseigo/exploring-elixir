defmodule ExploringElixir.Mixfile do
  use Mix.Project

  def project do
    [app: :exploring_elixir,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     aliases: aliases()]
  end

  def application do
    [
      # as a fist-full-of-demos, let's manually start our applications
      # note that this is NOT best practice; normally one would not
      # have an applications: entry at all and just let mix do its magic
      # on our behalf
      applications: applications(Mix.env),
      extra_applications: [:logger],
      mod: {ExploringElixir.Application, []}
    ]
  end

  defp applications(:dev), do: [:remix]
  defp applications(:test), do: [:remix]
  defp applications(_), do: []

  defp deps do
    [
      {:benchee, "~> 0.9.0"},
      {:benchee_html, "~> 0.3"},
      {:ecto, "~> 2.1.6"},
      {:flow, "~> 0.12" },
      {:libcluster, "~> 2.2.3"},
      {:poison, "~> 3.1.0"},
      {:postgrex, "~> 0.13.3"},
      {:timex, "~> 3.0"},
      {:triplex, "~> 0.9.0"},
      {:uuid, "~> 1.1.7"},

      # dev and test dependencies
      {:quixir, "~>0.9", only: :test},
      {:remix, "~> 0.0.2", only: [:dev, :test]},
      {:credo, "~> 0.8.6", only: [:dev, :test]}
    ]
  end

  defp aliases do
  end
end
