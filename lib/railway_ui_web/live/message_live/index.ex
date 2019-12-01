defmodule RailwayUiWeb.MessageLive.Index do
  alias RailwayUiWeb.MessageLive.Index.State
  alias RailwayUiWeb.Router.Helpers, as: Routes


  defmacro __using__(opts) do
    quote do
      use Phoenix.LiveView
      @message_type unquote(opts)[:message]
      @view unquote(opts)[:view]

      def render(assigns) do
        Phoenix.View.render(@view, "index.html", assigns)
      end

      def mount(%{current_user_uuid: current_user_uuid}, socket) do
        socket =
          socket
          |> assign(:messages, State.load_messages(@message_type))
          |> assign(:view, __MODULE__)
          |> assign(:data, State.new(@message_type, current_user_uuid))

        {:ok, socket, temporary_assigns: [messages: []]}
      end

      def handle_params(
            %{"page" => page_num, "search" => %{"query" => query, "value" => value}},
            _uri,
            %{assigns: %{data: data}} = socket
          ) do
        socket =
          socket
          |> assign(:data, State.for_search(@message_type, data, query, value, page_num))
          |> assign(:messages, State.messages_search(@message_type, query, value, page_num))

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
          |> assign(:messages, State.messages_page(@message_type, page_num))

        {:noreply, socket}
      end

      def handle_params(
            %{"search" => %{"query" => query, "value" => value}},
            _,
            %{assigns: %{data: data}} = socket
          ) do
        socket =
          socket
          |> assign(:data, State.for_search(@message_type, data, query, value))
          |> assign(:messages, State.messages_search(@message_type, query, value))

        {:noreply, socket}
      end

      def handle_params(
            _params,
            _,
            %{assigns: %{data: %{current_user_uuid: current_user_uuid}}} = socket
          ) do
        socket =
          socket
          |> assign(:data, State.new(@message_type, current_user_uuid))
          |> assign(:messages, State.load_messages(@message_type))

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
    end
  end
end
