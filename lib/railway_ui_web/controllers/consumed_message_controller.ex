defmodule RailwayUiWeb.ConsumedMessageController do
  use RailwayUiWeb, :controller
  alias RailwayUi.ConsumedMessage


  def index(conn, _params) do
    render(conn, "index.html", messages: ConsumedMessage.all())
  end
end
