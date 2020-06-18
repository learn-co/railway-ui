defmodule RailwayUiWeb.MessageViewHelper do
  def decode_message_body(%{message_type: message_type, encoded_message: encoded_message}) do
    %{"encoded_message" => message_to_decode} = Jason.decode!(encoded_message)

    try do
      stuff = message_type
      |> RailwayIpc.Core.Payload.module_from_type()
      |> RailwayIpc.Core.Payload.decode_message(message_to_decode)
      |> inspect(pretty: true)
    rescue
      UndefinedFunctionError -> "Unable to decode message due to missing message module"
      error -> error
    end
  end
end
