defmodule Seeder do
  @repo Application.get_env(:railway_ipc, :repo)
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

  def seed do
    for i <- 0..10, i > 0 do
      IO.puts("inserting messages #{i}")
      @repo.insert(consumed_message_factory())
      @repo.insert(published_message_factory())
    end
  end
end

Seeder.seed()
