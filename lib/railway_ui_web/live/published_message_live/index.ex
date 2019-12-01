defmodule RailwayUiWeb.PublishedMessageLive.Index do
  alias RailwayUiWeb.MessageLive.Index.State
  use RailwayUiWeb.MessageLive.Index,
    message: RailwayUi.PublishedMessage,
    view: RailwayUiWeb.PublishedMessageView
  @railway_ipc Application.get_env(:railway_ui, :railway_ipc, RailwayIpc)


  def handle_event(
        "republish",
        %{"message_uuid" => message_uuid},
        %{assigns: %{data: data}} = socket
      ) do
    case @railway_ipc.republish_message(message_uuid, State.request_data(data)) do
      :ok ->
        {:noreply, assign(socket, :data, State.flash_success(data, message_uuid))}

      {:error, error} ->
        {:noreply, assign(socket, :data, State.flash_error(data, message_uuid, error))}
    end
  end
end
