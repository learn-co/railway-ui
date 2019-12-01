defmodule RailwayUiWeb.MessageLive.Index.State do
  alias RailwayUiWeb.MessageLive.Index.Search
  @per_page 2
  @page "1"
  defstruct [:search, :current_user_uuid, :flash, :page, :page_nums, :query_filter, :query_value]

  def new(message_type, current_user_uuid) do
    %__MODULE__{
      flash: %{},
      current_user_uuid: current_user_uuid,
      page: String.to_integer(@page),
      page_nums: page_nums(message_type),
      search: %Search{}
    }
  end

  def load_messages(message_type) do
    message_type.all(%{limit: @per_page, page: String.to_integer(@page)})
  end

  def messages_page(message_type, page_num) do
    message_type.all(%{limit: @per_page, page: String.to_integer(page_num)})
  end

  def messages_search(message_type, query, value, page_num \\ @page) do
    try do
      message_type.search(query, value, %{limit: @per_page, page: String.to_integer(page_num)})
    rescue
      _e in Ecto.Query.CastError ->
        []
    end
  end

  def for_search(message_type, state, query, value, page_num \\ @page) do
    state
    |> set_search(query, value)
    |> set_page_nums(search_results_count(message_type, query, value))
    |> set_page(page_num)
  end

  def set_page(state, page_num) do
    update(state, %{page: String.to_integer(page_num)})
  end

  def set_search(state, query, value) do
    update(state, %{search: %Search{query: query, value: value}})
  end

  def set_search_query(%{search: %{query: _query, value: value}} = state, query) do
    update(state, %{search: %Search{query: query, value: value}})
  end

  def set_search_value(%{search: %{query: query, value: _value}} = state, value) do
    update(state, %{search: %Search{query: query, value: value}})
  end

  def set_page_nums(state, count) do
    update(state, %{page_nums: page_nums_for_count(count)})
  end

  def flash_success(state, message_uuid) do
    state
    |> Map.merge(%{flash: %{info: "Successfully published message #{message_uuid}!"}})
  end

  def flash_error(state, message_uuid, error) do
    state
    |> Map.merge(%{
      flash: %{error: "Failed to publish message #{message_uuid}, reason: #{inspect(error)}"}
    })
  end

  def request_data(%{current_user_uuid: current_user_uuid}) do
    %{
      correlation_id: Ecto.UUID.generate(),
      current_user: %{
        learn_uuid: current_user_uuid
      }
    }
  end

  defp update(state, attrs) do
    state
    |> Map.merge(attrs)
  end

  def page_nums_for_count(count) do
    count
    |> calculate_page_nums
  end

  def page_nums(message_type) do
    message_type.count()
    |> calculate_page_nums()
  end

  defp calculate_page_nums(page_count) do
    (page_count / @per_page)
    |> Float.ceil()
    |> Kernel.trunc()
  end

  defp search_results_count(message_type, query, value) do
    try do
      message_type.search_results_count(query, value)
    rescue
      _e in Ecto.Query.CastError ->
        0
    end
  end
end
