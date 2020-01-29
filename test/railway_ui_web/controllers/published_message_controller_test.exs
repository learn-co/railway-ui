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

  test "POST /republish", %{conn: conn} do
    uuid = Ecto.UUID.generate()

    RailwayIpcMock
    |> expect(:republish_message, fn ^uuid, _request_data ->
      :ok
    end)

    conn = post(conn, "/published_messages/republish", %{uuid: uuid})
    assert conn.status == 302
    assert get_flash(conn, :info) == "Sucessfully republished message with uuid: #{uuid}"
  end

  test "POST /republish fails", %{conn: conn} do
    uuid = Ecto.UUID.generate()

    RailwayIpcMock
    |> expect(:republish_message, fn ^uuid, _request_data ->
      {:error, "Error Message"}
    end)

    conn = post(conn, "/published_messages/republish", %{uuid: uuid})
    assert conn.status == 302

    assert get_flash(conn, :error) ==
             "Failed to republish message with uuid: #{uuid}. Reason: \"Error Message\""
  end
end
