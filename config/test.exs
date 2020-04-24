use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :railway_ui, RailwayUiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :railway_ui, persistence: RailwayUi.PersistenceMock
config :railway_ui, railway_ipc: RailwayIpcMock

# Configure your database
config :railway_ui, RailwayUi.Repo,
  username: System.get_env("PGUSER"),
  password: System.get_env("PGPASSWORD"),
  database: System.get_env("PGDATABASE"),
  hostname: System.get_env("PGHOST"),
  pool: Ecto.Adapters.SQL.Sandbox
