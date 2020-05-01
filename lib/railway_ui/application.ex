defmodule RailwayUi.Application do
  use Application
  @dev_repo Application.get_env(:railway_ui, :dev_repo)

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: RailwayUi.Supervisor]
    Supervisor.start_link(children(@dev_repo), opts)
  end

  def children(true),
    do: [RailwayUi.Repo, RailwayUiWeb.Endpoint, {Phoenix.PubSub, name: RailwayUi.PubSub}]

  def children(_), do: [RailwayUiWeb.Endpoint, {Phoenix.PubSub, name: RailwayUi.PubSub}]

  def config_change(changed, _new, removed) do
    RailwayUiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
