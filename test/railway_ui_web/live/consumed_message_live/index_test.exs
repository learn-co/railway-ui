defmodule RailwayUiWeb.ConsumedMessageLive.IndexTest do
  use Phoenix.ConnTest
  import Mox
  import Phoenix.LiveViewTest
  import RailwayUi.Factory
  import Plug.Test, only: [init_test_session: 2]
  use RailwayUiWeb.ConnCase
  @endpoint RailwayUiWeb.Endpoint

  setup :set_mox_global

  setup do
    current_user_uuid = Ecto.UUID.generate()

    consumed_messages =
      Enum.map(0..10, fn _num ->
        build(:consumed_message)
      end)

    RailwayUi.PersistenceMock
    |> stub(:get_consumed_messages, fn _params ->
      consumed_messages
    end)

    RailwayUi.PersistenceMock
    |> stub(:consumed_messages_count, fn ->
      10
    end)

    conn =
      build_conn()
      |> init_test_session(%{current_user_uuid: current_user_uuid})

    {:ok, view, html} = live(conn, "/consumed_messages")

    [
      view: view,
      html: html,
      consumed_messages: consumed_messages,
      current_user_uuid: current_user_uuid
    ]
  end

  test "connected mount", %{html: html} do
    assert html =~ "Consumed Messages"
  end

  test "it paginates", %{html: html, view: view, consumed_messages: consumed_messages} do
    assert html != Enum.at(consumed_messages, 2).uuid
    assert html != Enum.at(consumed_messages, 3).uuid
    html = render_live_link(view, "/consumed_messages?page=2")
    assert html =~ Enum.at(consumed_messages, 2).uuid
    assert html =~ Enum.at(consumed_messages, 3).uuid
  end


    test "it searches by message UUID", %{html: html, view: view, consumed_messages: consumed_messages} do
      message = Enum.at(consumed_messages, 3)
      query_filter = "uuid"
      query_value = message.uuid

      RailwayUi.PersistenceMock
      |> stub(:search_consumed_messages, fn ^query_filter, ^query_value, %{limit: 2, page: 1} ->
        [message]
      end)

      RailwayUi.PersistenceMock
      |> stub(:consumed_message_search_results_count, fn ^query_filter, ^query_value ->
        1
      end)

      assert html != Enum.at(consumed_messages, 3).uuid
      html = render_submit(view, :search, %{"search" => %{"query" => query_filter, "value" => query_value}})
      assert html =~ Enum.at(consumed_messages, 3).correlation_id
    end

    test "it searches by correlation ID", %{html: html, view: view, consumed_messages: consumed_messages} do
      message = Enum.at(consumed_messages, 3)
      query_filter = "correlation_id"
      query_value = message.correlation_id

      RailwayUi.PersistenceMock
      |> stub(:search_consumed_messages, fn ^query_filter, ^query_value, %{limit: 2, page: 1} ->
        [message]
      end)

      RailwayUi.PersistenceMock
      |> stub(:consumed_message_search_results_count, fn ^query_filter, ^query_value ->
        1
      end)

      assert html != Enum.at(consumed_messages, 3).uuid
      html = render_submit(view, :search, %{"search" => %{"query" => query_filter, "value" => query_value}})
      assert html =~ Enum.at(consumed_messages, 3).uuid
    end

    test "it searches by message type with pagination", %{html: html, view: view, consumed_messages: consumed_messages} do
      message = Enum.at(consumed_messages, 3)
      query_filter = "message_type"
      query_value = message.message_type

      RailwayUi.PersistenceMock
      |> stub(:search_consumed_messages, fn ^query_filter, ^query_value, %{limit: 2, page: 2} ->
        [message]
      end)

      RailwayUi.PersistenceMock
      |> stub(:consumed_message_search_results_count, fn ^query_filter, ^query_value ->
        1
      end)

      assert html != Enum.at(consumed_messages, 3).uuid
      html = render_submit(view, :search, %{"page" => "2", "search" => %{"query" => query_filter, "value" => query_value}})
      assert html =~ Enum.at(consumed_messages, 3).uuid
    end
end
