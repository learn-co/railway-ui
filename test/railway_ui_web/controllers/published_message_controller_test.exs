defmodule RailwayUiWeb.PublishedMessageControllerTest do
  use RailwayUiWeb.ConnCase
  use ExUnit.Case
  import RailwayUi.Factory
  import Mox

  test "GET /published_messages", %{conn: conn} do
    message = build(:published_message)

    RailwayUi.PersistenceMock
    |> expect(:get_published_messages, fn ->
      [message]
    end)

    conn = get(conn, "/published_messages")
    assert html_response(conn, 200) =~ "Published Messages"
  end
end
