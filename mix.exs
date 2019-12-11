defmodule RailwayUi.MixProject do
  use Mix.Project

  def project do
    [
      app: :railway_ui,
      version: "0.0.5",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      description: description(),
      package: package(),
      name: "Railway IPC UI",
      source_url: "https://github.com/learn-co/railway-ui"
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {RailwayUi.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.2"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:railway_ipc, "0.1.9"},
      {:ex_machina, "~> 2.3", only: :test},
      {:mox, "~> 0.5", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp description() do
    "The UI layer for the Railway IPC package"
  end

  defp package() do
    [
      description: "Railway IPC UI",
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/learn-co/railway-ui"}
    ]
  end
end
