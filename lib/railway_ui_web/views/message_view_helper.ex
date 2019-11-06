defmodule RailwayUiWeb.MessageViewHelper do

  def decode_message_body(message_body) do
    JASON.decode(message_body)
  end
end
