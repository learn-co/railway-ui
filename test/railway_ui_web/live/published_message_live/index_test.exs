defmodule RailwayUiWeb.PublishedMessageLive.IndexTest do
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
    published_message = build(:published_message)

    RailwayUi.PersistenceMock
    |> stub(:get_published_messages, fn ->
      [published_message]
    end)

    conn =
      build_conn()
      |> init_test_session(%{current_user_uuid: current_user_uuid})

    {:ok, view, html} = live(conn, "/published_messages")

    [
      view: view,
      html: html,
      published_message: published_message,
      current_user_uuid: current_user_uuid
    ]
  end

  test "connected mount", %{html: html} do
    assert html =~ "Published Messages"
  end

  test "republish message", %{
    view: view,
    published_message: published_message,
    current_user_uuid: current_user_uuid
  } do
    published_message_uuid = published_message.uuid

    RailwayIpcMock
    |> expect(:republish_message, fn ^published_message_uuid,
                                     %{
                                       correlation_id: _correlation_id,
                                       current_user: %{learn_uuid: ^current_user_uuid}
                                     } ->
      :ok
    end)

    html = render_click(view, :republish, %{"message_uuid" => published_message_uuid})
    assert html =~ "Successfully republished message"
  end

  # test "it sorts by name", %{view: view} do
  #   assert render_live_link(view, "/cohorts?sort_by=name&order=desc") =~
  #            "<th>Name<a data-phx-live-link=\"push\" href=\"/cohorts?order=asc&sort_by=name\" style=\"text-decoration: none\" to=\"/cohorts?order=asc&sort_by=name\">    ⤓</a></th>"
  # end
  #
  # test "it sorts by course offering", %{view: view} do
  #   assert render_live_link(view, "/cohorts?sort_by=course_offering&order=desc") =~
  #            "<th>Course Offering<a data-phx-live-link=\"push\" href=\"/cohorts?order=asc&sort_by=course_offering\" style=\"text-decoration: none\" to=\"/cohorts?order=asc&sort_by=course_offering\">    ⤓</a></th>"
  # end
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
