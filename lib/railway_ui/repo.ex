defmodule RailwayUi.Repo do
  use Ecto.Repo,
    otp_app: :railway_ui,
    adapter: Ecto.Adapters.Postgres
end
