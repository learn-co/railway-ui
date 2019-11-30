defmodule RailwayUiWeb.PublishedMessagesLive.Index do
  alias RailwayUi.PublishedMessage
  @railway_ipc Application.get_env(:railway_ui, :railway_ipc, RailwayIpc)

  use Phoenix.LiveView

   def render(assigns) do
     Phoenix.View.render(RailwayUiWeb.PublishedMessageView, "index.html", assigns)
   end

  def mount(%{current_user_uuid: current_user_uuid}, socket) do
    socket =
      socket
      |> assign(:messages, load_messages())
      |> assign(:current_user_uuid, current_user_uuid)
      |> assign(:flash, %{})
    {:ok, socket, temporary_assigns: [messages: []]}
  end

  def handle_event("republish", %{"message_uuid" => message_uuid}, socket) do
    case @railway_ipc.republish_message(message_uuid, request_data(socket)) do
      :ok ->
        {:noreply, assign(socket, :flash, %{info: "Successfully republished message #{message_uuid}!"})}

      {:error, error} ->
        {:noreply, assign(socket, :flash, %{error: "Failed to republish message #{message_uuid}, reason: #{inspect(error)}"})}
    end
  end

  defp request_data(%{assigns: %{current_user_uuid: current_user_uuid}}) do
    %{
      correlation_id: Ecto.UUID.generate(),
      current_user: %{
        learn_uuid: current_user_uuid
      }
    }
  end

  defp load_messages do
    PublishedMessage.all()
  end
end
