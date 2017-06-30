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

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      extra_applications: [:logger],
      mod: {ExploringElixir.Application, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:flow, "~> 0.11" },
      {:poison, "~> 3.1.0"},
      {:ecto, "~> 2.1.4"},
      {:postgrex, "~> 0.13.3"},
      {:timex, "~> 3.0"},
      {:benchee, "~> 0.9.0"},
      {:benchee_html, "~> 0.3"},
      {:uuid, "~> 1.1.7"},
      {:remix, "~> 0.0.2", only: :dev},
      {:credo, "~> 0.8.1", only: :dev}
    ]
  end
end
