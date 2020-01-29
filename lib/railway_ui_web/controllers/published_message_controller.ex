defmodule RailwayUiWeb.PublishedMessageController do
  use RailwayUiWeb, :controller
  alias RailwayUi.PublishedMessage
  @railway_ipc Application.get_env(:railway_ui, :railway_ipc, RailwayIpc)

  def index(conn, _params) do
    render(conn, "index.html", messages: PublishedMessage.all())
  end

  def republish(conn, %{"uuid" => uuid}) do
    case @railway_ipc.republish_message(uuid, request_data(conn)) do
      :ok ->
        conn
        |> put_flash(:info, "Sucessfully republished message with uuid: #{uuid}")
        |> redirect(to: Routes.published_message_path(conn, :index))

      {:error, error} ->
        conn
        |> put_flash(
          :error,
          "Failed to republish message with uuid: #{uuid}. Reason: #{inspect(error)}"
        )
        |> redirect(to: Routes.published_message_path(conn, :index))
    end
  end

  def request_data(conn) do
    current_user_uuid = get_session(conn, :current_user_uuid)

    %{
      correlation_id: Ecto.UUID.generate(),
      current_user: %{
        learn_uuid: current_user_uuid
      }
    }
  end
end
