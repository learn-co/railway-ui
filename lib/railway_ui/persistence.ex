defmodule RailwayUi.Persistence do
  require Ecto.Query
  @repo Application.get_env(:railway_ipc, :repo)
  alias RailwayIpc.Persistence.{PublishedMessage, ConsumedMessage}

  def get_consumed_messages(%{limit: limit, page: page}) do
    ConsumedMessage
    |> get_messages(limit, page)
  end

  def get_published_messages(%{limit: limit, page: page}) do
    PublishedMessage
    |> get_messages(limit, page)
  end

  def consumed_messages_count do
    Ecto.Query.from(m in ConsumedMessage)
    |> get_count()
  end

  def published_messages_count do
    Ecto.Query.from(m in PublishedMessage)
    |> get_count()
  end

  def count_published_message_search_results(query_filter, query_value) do
    search_query(PublishedMessage, query_filter, query_value)
    |> get_count()
  end

  def count_consumed_message_search_results(query_filter, query_value) do
    search_query(ConsumedMessage, query_filter, query_value)
    |> get_count()
  end

  def search_published_messages(query_filter, query_value, %{limit: limit, page: page}) do
    search_query(PublishedMessage, query_filter, query_value)
    |> pagination_query(limit, page)
    |> @repo.all()
  end

  def search_consumed_messages(query_filter, query_value, %{limit: limit, page: page}) do
    search_query(ConsumedMessage, query_filter, query_value)
    |> pagination_query(limit, page)
    |> @repo.all()
  end

  defp get_count(query) do
    query
    |> @repo.aggregate(:count, :uuid)
  end

  defp get_messages(struct, limit, page) do
    struct
    |> pagination_query(limit, page)
    |> @repo.all()
  end

  defp calculate_offset(page) do
    (page - 1) * 2
  end

  defp search_query(struct, query_filter, query_value) do
    filter = Keyword.new([{String.to_atom(query_filter), query_value}])

    Ecto.Query.from(m in struct, where: ^filter)
  end

  defp pagination_query(query, limit, page) do
    query
    |> Ecto.Query.limit(^limit)
    |> Ecto.Query.offset(^calculate_offset(page))
  end
end
