defmodule RailwayUiWeb.PublishedMessageControllerTest do
  use RailwayUiWeb.ConnCase

  test "GET /published_messages", %{conn: conn} do
    conn = get(conn, "/published_messages")
    assert html_response(conn, 200) =~ "Published Messages"
  end
end
