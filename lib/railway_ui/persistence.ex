defmodule RailwayUi.Persistence do
  require Ecto.Query
  @repo Application.get_env(:railway_ipc, :repo)
  alias RailwayIpc.Persistence.{PublishedMessage, ConsumedMessage}

  def get_consumed_messages do
    ConsumedMessage
    |> @repo.all()
  end

  def get_published_messages(%{limit: limit, page: "1"}) do
    PublishedMessage
    |> get_messages(limit)
  end

  def get_published_messages(%{limit: limit, page: page}) do
    PublishedMessage
    |> get_messages(limit, page)
  end

  def published_messages_count do
    Ecto.Query.from(m in PublishedMessage)
    |> get_count()
  end

  def search_published_messages(query_filter, query_value) do
    filter = Keyword.new([{String.to_atom(query_filter), query_value}])

    Ecto.Query.from(m in PublishedMessage, where: ^filter)
    |> @repo.all()
  end

  defp get_count(query) do
    query
    |> @repo.aggregate(:count, :uuid)
  end

  defp get_messages(struct, limit) do
    struct
    |> Ecto.Query.limit(^limit)
    |> @repo.all()
  end

  defp get_messages(struct, limit, page) do
    struct
    |> Ecto.Query.limit(^limit)
    |> Ecto.Query.offset(^calculate_offset(page))
    |> @repo.all()
  end

  defp calculate_offset(page) do
    (String.to_integer(page) - 1) * 2
  end
end
