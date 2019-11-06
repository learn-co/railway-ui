defmodule RailwayUi.Factory do
  use ExMachina.Ecto, repo: RailwayUi.Repo
  alias RailwayIpc.Persistence.{ConsumedMessage, PublishedMessage}

  def consumed_message_factory do
    %ConsumedMessage{
      uuid: Ecto.UUID.generate(),
      message_type: "BatchCreated",
      user_uuid: Ecto.UUID.generate(),
      correlation_id: Ecto.UUID.generate(),
      encoded_message: "{\"encoded_message\":\"\",\"type\":\"Events::BatchCreated\"}",
      status: "success",
      queue: "queue",
      exchange: "exchange"
    }
  end

  def published_messag_factory do
    %ConsumedMessage{
      uuid: Ecto.UUID.generate(),
      message_type: "BatchCreated",
      user_uuid: Ecto.UUID.generate(),
      correlation_id: Ecto.UUID.generate(),
      encoded_message: "{\"encoded_message\":\"\",\"type\":\"Events::BatchCreated\"}",
      status: "sent",
      exchange: "exchange"
    }
  end
end
