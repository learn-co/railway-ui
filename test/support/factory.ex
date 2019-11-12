defmodule RailwayUi.Factory do
  use ExMachina.Ecto, repo: RailwayUi.Repo
  alias RailwayIpc.Persistence.{ConsumedMessage, PublishedMessage}

  def consumed_message_factory do
    %{
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

  def published_message_factory do
    %PublishedMessage{
      uuid: Ecto.UUID.generate(),
      message_type: "CreateBatch",
      user_uuid: Ecto.UUID.generate(),
      correlation_id: Ecto.UUID.generate(),
      encoded_message: "{\"encoded_message\":\"\",\"type\":\"Events::CreateBatch\"}",
      status: "sent",
      exchange: "exchange"
    }
  end
end
