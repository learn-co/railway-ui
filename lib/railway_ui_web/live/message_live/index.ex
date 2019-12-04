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
          |> assign(:view, __MODULE__)
          |> assign(:state, State.new(@message_type, current_user_uuid))
          |> assign(:messages, State.load_messages(@message_type))
        {:ok, socket, temporary_assigns: [messages: nil]}
      end

      def handle_params(
            %{"page" => page_num, "search" => %{"query" => query, "value" => value}},
            _uri,
            %{assigns: %{state: state}} = socket
          ) do
        socket =
          socket
          |> assign(:state, State.for_search(@message_type, state, query, value, page_num))
          |> assign(:messages, State.messages_search(@message_type, query, value, page_num))

        {:noreply, socket}
      end

      def handle_params(
            %{"page" => page_num},
            _uri,
            %{assigns: %{state: state}} = socket
          ) do
        socket =
          socket
          |> assign(:state, State.set_page(state, page_num))
          |> assign(:messages, State.messages_page(@message_type, page_num))

        {:noreply, socket}
      end

      def handle_params(
            %{"search" => %{"query" => query, "value" => value}},
            _,
            %{assigns: %{state: state}} = socket
          ) do
        socket =
          socket
          |> assign(:state, State.for_search(@message_type, state, query, value))
          |> assign(:messages, State.messages_search(@message_type, query, value))

        {:noreply, socket}
      end

      def handle_params(
            _params,
            _,
            %{assigns: %{state: %{current_user_uuid: current_user_uuid} = state}} = socket
          ) do
        socket =
          socket
          |> assign(:state, State.new(@message_type, current_user_uuid))
          |> assign(:messages, State.load_messages(@message_type))
        {:noreply, socket}
      end

      def handle_info({:search, params}, socket) do
        {:noreply,
         live_redirect(socket,
           to: Routes.live_path(socket, __MODULE__, params)
         )}
      end

      def handle_info(:clear, socket) do
        {:noreply,
         live_redirect(socket,
           to: Routes.live_path(socket, __MODULE__, %{})
         )}
      end
    end
  end
end
