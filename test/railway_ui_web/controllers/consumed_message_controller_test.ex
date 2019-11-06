defmodule RailwayUiWeb.ConsumedMessageControllerTest do
  use RailwayUiWeb.ConnCase

  test "GET /consumed_messages", %{conn: conn} do
    conn = get(conn, "/consumed_messages")
    assert html_response(conn, 200) =~ "Consumed Messages"
  end
end
