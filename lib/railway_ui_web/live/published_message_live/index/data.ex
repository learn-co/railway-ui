defmodule RailwayUiWeb.PublishedMessageLive.Index.Data do
  alias RailwayUi.PublishedMessage
  defstruct [:current_user_uuid, :flash, :page, :page_nums, :query_filter, :query_value]

  def new(current_user_uuid) do
    %__MODULE__{
      flash: %{},
      current_user_uuid: current_user_uuid,
      page: 1,
      page_nums: PublishedMessage.page_nums(),
      query_filter: nil,
      query_value: nil,
    }
  end

  def reset_messages(current_user_uuid) do
    %__MODULE__{
      flash: %{},
      current_user_uuid: current_user_uuid,
      page: 1,
      page_nums: PublishedMessage.page_nums(),
      query_filter: nil,
      query_value: nil
    }
  end

  def messages_page(page_num) do
    PublishedMessage.all(page_num)
  end

  def messages_search(query_filter, query_value) do
    PublishedMessage.search(query_filter, query_value)
  end

  def set_page(data, page_num) do
    update(data, %{page: String.to_integer(page_num)})
  end

  def set_query_info(data, query_filter, query_value) do
    update(data, %{query_filter: query_filter, query_value: query_value})
  end

  def set_query_filter(data, query_filter) do
    update(data, %{query_filter: query_filter})
  end
  
  def load_messages do
    PublishedMessage.all()
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

  def update(data, attrs) do
    data
    |> Map.merge(attrs)
  end
end
