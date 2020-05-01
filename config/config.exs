# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :railway_ui,
  ecto_repos: [RailwayUi.Repo]

# Configures the endpoint
config :railway_ui, RailwayUiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "r+27+XkFRv3Cev7AgigTQ9GXu5cfqs4t7iajQEUUiiyeLyn7P6GbKgLyHZqPJiTW",
  render_errors: [view: RailwayUiWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: RailwayUi.PubSub,
  live_view: [signing_salt: System.get_env("SIGNING_SECRET")]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :railway_ipc, repo: RailwayUi.Repo
config :railway_ipc, start_supervisor: true
config :railway_ipc, mix_env: Mix.env()
config :railway_ui, dev_repo: true
config :railway_ui, persistence: RailwayUi.Persistence

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
