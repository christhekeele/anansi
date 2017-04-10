defmodule Anansi.Mixfile do
  use Mix.Project

  def project, do: [
    app: :anansi,

    elixir: "~> 1.0",
    build_embedded:  Mix.env == :prod,
    start_permanent: Mix.env == :prod,
    deps: deps(),

    version: "0.0.1",
    name: "Anansi",
    source_url: package()[:Source],
    homepage_url: package()[:Homepage],

    docs: docs(),

    package: package(),
  ]

  def application, do: [
    applications: [],
  ]

  defp deps, do: [
    {:earmark, ">= 0.0.0", only: :dev},
    {:ex_doc,  ">= 0.0.0", only: :dev},
  ]

  defp docs, do: [
    # logo: "path/to/logo.png",
    extras: [
      "README.md",
      "LICENSE.md",
      "CONTRIBUTORS.md",
    ],
  ]

  defp package, do: [
    description: "Command the terminal from a high-level with ANSI control codes.",
    maintainers: [
      "Chris Keele <dev@chriskeele.com>",
    ],
    licenses: [
      "MIT",
    ],
    links: %{
      Source: "https://github.com/christhekeele/anansi",
      Homepage: "http://christhekeele.github.io/anansi",
      Tests: "https://travis-ci.org/christhekeele/anansi",
    }
  ]

end
