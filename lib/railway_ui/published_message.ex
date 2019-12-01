defmodule RailwayUi.PublishedMessage do
  @persistence Application.get_env(:railway_ui, :persistence, RailwayUi.Persistence)

  def all(%{limit: _limit, page: _page} = params) do
    @persistence.get_published_messages(params)
  end

  def search(query_filter, query_value, %{limit: _limit, page: _page} = params) do
    @persistence.search_published_messages(query_filter, query_value, params)
  end

  def count do
    @persistence.published_messages_count()
  end

  def search_results_count(query_filter, query_value) do
    @persistence.count_published_message_search_results(query_filter, query_value)
  end
end
