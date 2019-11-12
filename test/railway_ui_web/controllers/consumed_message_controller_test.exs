defmodule RailwayUiWeb.ConsumedMessageControllerTest do
  use RailwayUiWeb.ConnCase
  use ExUnit.Case
  import RailwayUi.Factory
  import Mox

  test "GET /consumed_messages", %{conn: conn} do
    message = build(:consumed_message)

    RailwayUi.PersistenceMock
    |> expect(:get_consumed_messages, fn ->
      [message]
    end)

    conn = get(conn, "/consumed_messages")
    assert html_response(conn, 200) =~ "Consumed Messages"
    assert html_response(conn, 200) =~ "BatchCreated"
  end
end
