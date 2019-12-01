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

  #
  # test "it searches by UUID", %{
  #   view: view,
  #   core_cohort: core_cohort,
  #   second_core_cohort: second_core_cohort
  # } do
  #   html = render_submit(view, :uuid_search, %{uuid: core_cohort.uuid})
  #   assert html =~ core_cohort.uuid
  #   refute html =~ second_core_cohort.uuid
  # end
end
