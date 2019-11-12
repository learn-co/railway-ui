defmodule RailwayUiWeb.PageControllerTest do
  use RailwayUiWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Railway IPC UI"
  end
end
