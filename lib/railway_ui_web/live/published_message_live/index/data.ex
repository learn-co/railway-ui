defmodule RailwayUiWeb.PublishedMessageLive.Index.Data do
  alias RailwayUi.PublishedMessage
  defstruct [:messages, :current_user_uuid, :flash]

  def new(current_user_uuid) do
    %__MODULE__{
      messages: PublishedMessage.all(),
      flash: %{},
      current_user_uuid: current_user_uuid
    }
  end

  def reset_messages(current_user_uuid) do
    %__MODULE__{
      messages: [],
      flash: %{},
      current_user_uuid: current_user_uuid
    }
  end

  def flash_success(data, message_uuid) do
    data
    |> Map.merge(%{flash: %{info: "Successfully republished message #{message_uuid}!"}})
  end

  def flash_error(data, message_uuid, error) do
    data
    |> Map.merge(%{flash: %{error: "Failed to republish message #{message_uuid}, reason: #{inspect(error)}"}})
  end

  def request_data(%{current_user_uuid: current_user_uuid}) do
    %{
      correlation_id: Ecto.UUID.generate(),
      current_user: %{
        learn_uuid: current_user_uuid
      }
    }
  end
end
