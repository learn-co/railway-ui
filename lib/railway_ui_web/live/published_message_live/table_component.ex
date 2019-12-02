defmodule RailwayUiWeb.PublishedMessageLive.TableComponent do
  use Phoenix.LiveComponent

  alias RailwayUiWeb.MessageLive.Index.State
  use Phoenix.LiveView
  @railway_ipc Application.get_env(:railway_ui, :railway_ipc, RailwayIpc)

  def render(assigns) do
    Phoenix.View.render(RailwayUiWeb.PublishedMessageView, "table_component.html", assigns)
  end

  def handle_event(
        "republish",
        %{"message_uuid" => message_uuid},
        %{assigns: %{state: state}} = socket
      ) do
    case @railway_ipc.republish_message(message_uuid, State.request_data(state)) do
      :ok ->
        {:noreply, assign(socket, :state, State.flash_success(state, message_uuid))}

      {:error, error} ->
        {:noreply, assign(socket, :state, State.flash_error(state, message_uuid, error))}
    end
  end
end
