defmodule RailwayUiWeb.PublishedMessageLive.Index do
  alias RailwayUiWeb.PublishedMessageLive.Index.State
  alias RailwayUiWeb.Router.Helpers, as: Routes
  @railway_ipc Application.get_env(:railway_ui, :railway_ipc, RailwayIpc)

  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(RailwayUiWeb.PublishedMessageView, "index.html", assigns)
  end

  def mount(%{current_user_uuid: current_user_uuid}, socket) do
    socket =
      socket
      |> assign(:messages, State.load_messages())
      |> assign(:data, State.new(current_user_uuid))

    {:ok, socket, temporary_assigns: [messages: []]}
  end

  def handle_params(
        %{"page" => page_num, "search" => %{"query" => query, "value" => value}},
        _uri,
        %{assigns: %{data: data}} = socket
      ) do
    socket =
      socket
      |> assign(:data, State.for_search(data, query, value, page_num))
      |> assign(:messages, State.messages_search(query, value, page_num))

    {:noreply, socket}
  end

  def handle_params(
        %{"page" => page_num},
        _uri,
        %{assigns: %{data: data}} = socket
      ) do
    socket =
      socket
      |> assign(:data, State.set_page(data, page_num))
      |> assign(:messages, State.messages_page(page_num))

    {:noreply, socket}
  end

  def handle_params(
        %{"search" => %{"query" => query, "value" => value}},
        _,
        %{assigns: %{data: data}} = socket
      ) do
    socket =
      socket
      |> assign(:data, State.for_search(data, query, value))
      |> assign(:messages, State.messages_search(query, value))

    {:noreply, socket}
  end

  def handle_params(
        _params,
        _,
        %{assigns: %{data: %{current_user_uuid: current_user_uuid}}} = socket
      ) do
    socket =
      socket
      |> assign(:data, State.new(current_user_uuid))
      |> assign(:messages, State.load_messages())

    {:noreply, socket}
  end

  def handle_event("search", params, socket) do
    {:noreply,
     live_redirect(socket,
       to: Routes.live_path(socket, __MODULE__, params)
     )}
  end

  def handle_event("search_by", %{"query" => query}, %{assigns: %{data: data}} = socket) do
    {:noreply, assign(socket, :data, State.set_search(data, query))}
  end

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
