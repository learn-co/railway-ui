defmodule RailwayUiWeb.PublishedMessageController do
  use RailwayUiWeb, :controller
  alias RailwayUi.PublishedMessage

  def index(conn, _params) do
    render(conn, "index.html", messages: PublishedMessage.all())
  end
end
