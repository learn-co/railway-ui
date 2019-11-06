defmodule RailwayUi.Persistence do
  @repo Application.get_env(:railway_ipc, :repo)

  def get_consumed_messages do
    RailwayIpc.Persistence.ConsumedMessage
    |> @repo.all()
  end

  def get_published_messages do
    RailwayIpc.Persistence.PublishedMessage
    |> @repo.all()
  end
end
