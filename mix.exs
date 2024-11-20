defmodule LivePalette.MixProject do
  use Mix.Project

  @version "0.1.1"

  def project do
    [
      app: :live_palette,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_path(Mix.env()),
      deps: deps(),
      name: "LivePalette",
      description: "A command palette for LiveView",
      source_url: "https://github.com/probably-not/live-palette",
      homepage_url: "https://github.com/probably-not/live-palette",
      package: [
        maintainers: ["Coby Benveniste"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/probably-not/live-palette"},
        files: [
          "lib",
          ".formatter.exs",
          "mix.exs",
          "README*",
          "LICENSE*",
          "CHANGELOG*"
        ]
      ],
      aliases: aliases(),
      docs: docs(),
      dialyzer: [
        plt_add_apps: [:mix],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        plt_add_deps: :app_tree
      ],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        ci: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.github": :test,
        "coveralls.html": :test,
        "coveralls.json": :test,
        "coveralls.post": :test
      ]
    ]
  end

  defp elixirc_path(:test), do: ["lib/", "test/support", "bench/"]
  defp elixirc_path(:dev), do: ["lib/", "bench/"]
  defp elixirc_path(_), do: ["lib/"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: applications(Mix.env())
    ]
  end

  defp applications(:dev),
    do: applications(:all) ++ [:remixed_remix, :runtime_tools]

  defp applications(_all), do: [:logger]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_live_view, "~> 1.0.0-rc.6"},
      ## Testing and Development Dependencies
      {:ex_doc, "~> 0.35.0", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:remixed_remix, "~> 2.0.2", only: :dev},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:benchee, "~> 1.0", only: :dev},
      {:benchee_markdown, "~> 0.3", only: :dev}
    ]
  end

  defp aliases do
    [
      quality: ["format", "credo --strict", "dialyzer"],
      ci: [
        "coveralls",
        "format --check-formatted",
        "credo --strict",
        "dialyzer"
      ]
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "CHANGELOG.md": [title: "Changelog"],
        "README.md": [title: "README"]
      ],
      source_ref: @version,
      skip_undefined_reference_warnings_on: Path.wildcard("**/*.md"),
      groups_for_extras: []
    ]
  end
end
