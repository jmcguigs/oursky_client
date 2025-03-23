defmodule OurskyClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :oursky_client,
      version: "0.1.3",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      name: "OurskyClient",
      source_url: "https://github.com/jmcguigs/oursky_client"
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
      {:req, "~> 0.5.8"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    """
    A client for the Oursky SDA API.
    """
  end

  defp package() do
    [
      name: :oursky_client,
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/jmcguigs/oursky_client"}
    ]
  end
end
