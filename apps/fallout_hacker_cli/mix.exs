defmodule FalloutHacker.CLI.Mixfile do
  use Mix.Project

  def project do
    [
      app: :fallout_hacker_cli,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      escript: [main_module: FalloutHacker.CLI],
      build_embedded: Mix.env == :prod,
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
      {:fallout_hacker_core, in_umbrella: true},
    ]
  end
end
