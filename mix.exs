defmodule Haex.MixProject do
  @moduledoc false

  use Mix.Project

  @vsn "0.0.4"

  def project do
    [
      app: :haex,
      version: @vsn,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      description:
        "Haskell as Elixir - A DSL for implementing Haskell style sum and product data types in Elixir",
      package: package(),
      source_url: "https://github.com/madlep/haex",
      homepage_url: "https://github.com/madlep/haex",
      docs: [
        main: "readme",
        extras: ["README.md"],
        source_ref: @vsn
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp elixirc_paths(:dev), do: ["lib", "examples"]
  defp elixirc_paths(:test), do: ["lib", "examples"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/madlep/haex",
        "Twitter" => "https://twitter.com/madlep"
      }
    ]
  end
end
