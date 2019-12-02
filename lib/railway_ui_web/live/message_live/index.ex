defmodule RailwayUiWeb.MessageLive.Index do
  alias RailwayUiWeb.MessageLive.Index.State
  alias RailwayUiWeb.Router.Helpers, as: Routes
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(RailwayUiWeb.MessageView, "index.html", assigns)
  end

  def mount(%{current_user_uuid: current_user_uuid} = session, socket) do
    socket =
      socket
      |> assign(:state, State.new(current_user_uuid))
    {:ok, socket, temporary_assigns: [messages: nil]}
  end

  def handle_params(
        %{"page" => page_num, "search" => %{"query" => query, "value" => value}},
        uri,
        %{assigns: %{state: state}} = socket
      ) do
    %{path: "/" <> message_type} = URI.parse(uri)
    state = State.new(state, message_type, page_num)
    socket =
      socket
      |> assign(:state, State.for_search(state, query, value, page_num))
      |> assign(:messages, State.messages_search(state, query, value, page_num))

    {:noreply, socket}
  end

  def handle_params(
        %{"page" => page_num},
        uri,
        %{assigns: %{state: state}} = socket
      ) do
    %{path: "/" <> message_type} = URI.parse(uri)
    state = State.new(state, message_type, page_num)
    socket =
      socket
      |> assign(:state, state)
      |> assign(:messages, State.messages_page(state, page_num))

    {:noreply, socket}
  end

  def handle_params(
        %{"search" => %{"query" => query, "value" => value}},
        uri,
        %{assigns: %{state: state}} = socket
      ) do
    %{path: "/" <> message_type} = URI.parse(uri)
    state = State.new(state, message_type)
    socket =
      socket
      |> assign(:state, State.for_search(state, query, value))
      |> assign(:messages, State.messages_search(state, query, value))

    {:noreply, socket}
  end
  def handle_params(
        _params,
        uri,
        %{assigns: %{state: state}} = socket
      ) do
    %{path: "/" <> message_type} = URI.parse(uri)
    state = State.new(state, message_type)
    socket =
      socket
      |> assign(:state, state)
      |> assign(:messages, State.load_messages(state))

    {:noreply, socket}
  end

  def handle_event("search", params, socket) do
    {:noreply,
     live_redirect(socket,
       to: Routes.live_path(socket, __MODULE__, params)
     )}
  end

  def handle_event(
        "search_form_change",
        %{"_target" => ["search", "value"], "search" => %{"value" => value}},
        %{assigns: %{state: state}} = socket
      ) do
    {:noreply, assign(socket, :state, State.set_search_value(state, value))}
  end

  def handle_event(
        "search_form_change",
        %{"_target" => ["search", "query"], "search" => %{"query" => query}},
        %{assigns: %{state: state}} = socket
      ) do
    {:noreply, assign(socket, :state, State.set_search_query(state, query))}
  end

  def handle_event(
        "search_form_change",
        %{"_target" => ["search", "query"], "search" => %{"value" => _value}},
        socket
      ) do
    {:noreply, socket}
  end
end
