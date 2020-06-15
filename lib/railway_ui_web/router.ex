defmodule RailwayUiWeb.Router do
  use RailwayUiWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RailwayUiWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/published_messages", PublishedMessageController, :index
    post "/published_messages/republish", PublishedMessageController, :republish
    get "/consumed_messages", ConsumedMessageController, :index
    live_dashboard "/dashboard"
  end

  # Other scopes may use custom stacks.
  # scope "/api", RailwayUiWeb do
  #   pipe_through :api
  # end
end
