defmodule YelpElixir.Mixfile do
  use Mix.Project

  def project do
    [app: :yelp_elixir,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :oauth2]]
  end

  defp deps do
    [{:oauth2, "~> 0.8"},
     {:poison, "~> 3.0"}]
  end
end