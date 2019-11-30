defmodule RailwayUiWeb.PublishedMessageLive.Index.State do
  alias RailwayUi.PublishedMessage
  alias RailwayUiWeb.PublishedMessageLive.Index.Search
  @per_page 2
  @page "1"
  defstruct [:search, :current_user_uuid, :flash, :page, :page_nums, :query_filter, :query_value]

  def new(current_user_uuid) do
    %__MODULE__{
      flash: %{},
      current_user_uuid: current_user_uuid,
      page: String.to_integer(@page),
      page_nums: page_nums(),
      search: %Search{}
    }
  end

  def reset_messages(current_user_uuid) do
    %__MODULE__{
      flash: %{},
      current_user_uuid: current_user_uuid,
      page: String.to_integer(@page),
      page_nums: page_nums(),
      search: %Search{}
    }
  end

  def load_messages do
    PublishedMessage.all(%{limit: @per_page, page: String.to_integer(@page)})
  end

  def messages_page(page_num) do
    PublishedMessage.all(%{limit: @per_page, page: String.to_integer(page_num)})
  end

  def messages_search(query, value, page_num \\ @page) do
    PublishedMessage.search(query, value, %{limit: @per_page, page: String.to_integer(page_num)})
  end

  def for_search(data, query, value, page_num \\ @page) do
    data
    |> set_search(query, value)
    |> set_page_nums(PublishedMessage.search_results_count(query, value))
    |> set_page(page_num)
  end

  def set_page(data, page_num) do
    update(data, %{page: String.to_integer(page_num)})
  end

  def set_search(data, query, value) do
    update(data, %{search: %Search{query: query, value: value}})
  end

  def set_search(data, query) do
    update(data, %{search: %Search{query: query}})
  end

  def set_page_nums(data, count) do
    update(data, %{page_nums: page_nums_for_count(count)})
  end

  def flash_success(data, message_uuid) do
    data
    |> Map.merge(%{flash: %{info: "Successfully republished message #{message_uuid}!"}})
  end

  def flash_error(data, message_uuid, error) do
    data
    |> Map.merge(%{
      flash: %{error: "Failed to republish message #{message_uuid}, reason: #{inspect(error)}"}
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

  defp update(data, attrs) do
    data
    |> Map.merge(attrs)
  end

  def page_nums_for_count(count) do
    count
    |> calculate_page_nums
  end

  def page_nums do
    PublishedMessage.count()
    |> calculate_page_nums()
  end

  defp calculate_page_nums(page_count) do
    (page_count / @per_page)
    |> Float.ceil()
    |> Kernel.trunc()
  end
end
