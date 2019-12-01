defmodule RailwayUi.PersistenceBehaviour do
  @moduledoc false
  alias RailwayIpc.Persistence.{PublishedMessage, ConsumedMessage}

  @callback get_consumed_messages(params :: Map.t()) :: [ConsumedMessage.t()]
  @callback get_published_messages(params :: Map.t()) :: [PublishedMessage.t()]
  @callback published_messages_count() :: Integer.t()
  @callback consumed_messages_count() :: Integer.t()
  @callback search_published_messages(Ecto.Query.t(), query_filter :: String.t(), query_value :: String.t()) :: [
              ConsumedMessage.t()
            ]
  @callback search_consumed_messages(Ecto.Query.t(), query_filter :: String.t(), query_value :: String.t()) :: [
              ConsumedMessage.t()
            ]
  @callback count_published_message_search_results(query_filter :: String.t(), query_value :: String.t()) :: Integer.t()
  @callback count_consumed_message_search_results(query_filter :: String.t(), query_value :: String.t()) :: Integer.t()
end
