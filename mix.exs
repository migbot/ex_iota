defmodule Iota.Mixfile do
  use Mix.Project

  def project do
    [
      app: :iota,
      description: "A wrapper for the IOTA API written in Elixir",
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:httpoison, "~> 0.13"}
    ]
  end

  defp app_version do
    with {out, 0} <- System.cmd("git", ~w[describe], stderr_to_stdout: true) do
      out
      |> String.trim
      |> String.split("-")
      |> Enum.take(2)
      |> Enum.join(".")
      |> String.trim_leading("v")
    else
      _ -> "0.1.0"
    end
  end
end
