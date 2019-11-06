defmodule RailwayUiWeb.PageController do
  use RailwayUiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
