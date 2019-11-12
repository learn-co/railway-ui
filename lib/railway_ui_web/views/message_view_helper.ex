defmodule RailwayUiWeb.MessageViewHelper do
  def decode_message_body(message_body) do
    inspect(Jason.decode!(message_body))
  end
end
