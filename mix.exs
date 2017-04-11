defmodule Anansi.Mixfile do
  use Mix.Project

  def project, do: [
    name: "Anansi",
    app: :anansi,

    version: "0.0.1",
    elixir: "~> 1.0",

    build_embedded: Mix.env == :prod,
    start_permanent: Mix.env == :prod,

    deps: deps(),
    docs: docs(),
    package: package(),

    source_url:   package()[:links][:Source],
    homepage_url: package()[:links][:Homepage],

    test_coverage: coverage(),
    dialyzer: dialyzer(),
  ]

  def application, do: [
    extra_applications: [:logger],
    mod: {Anansi, []},
  ]

  defp deps, do: tools()

  defp tools, do: [
    {:dialyxir,    "~> 0.5",  only: :dev},
    {:ex_doc,      "~> 0.15", only: :dev},
    {:excoveralls, "~> 0.6",  only: :test},
    {:credo,       "~> 0.6",  only: [:dev, :test]},
    {:benchfella,  "~> 0.3",  only: [:dev, :test]},
    {:inch_ex,     "~> 0.5",  only: [:dev, :test]},
  ]

  defp docs, do: [
    main: "Anansi",
    # logo: "anansi.png",
    extras: [
      "README.md",
      "CREDITS.md",
      "LICENSE.md",
    ]
  ]

  defp package, do: [
    description: "Command the terminal from a high-level with ANSI control codes.",
    maintainers: [
      "Chris Keele <christhekeele+anansi@gmail.com>",
    ],
    licenses: [
      "MIT",
    ],
    links: %{
      Homepage: "https://christhekeele.github.io/anansi",
      Source: "https://github.com/christhekeele/anansi",
      Tests: "https://travis-ci.org/christhekeele/anansi",
      Coverage: "https://coveralls.io/github/christhekeele/anansi",
    }
  ]

  defp coverage, do: [
    tool: ExCoveralls,
    coveralls: true,
  ]

  defp dialyzer, do: [
    plt_add_apps: [
      :mnesia,
      # :ecto,
    ]
  ]

end
