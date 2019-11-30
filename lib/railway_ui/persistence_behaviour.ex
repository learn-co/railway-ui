defmodule RailwayUi.PersistenceBehaviour do
  @moduledoc false
  alias RailwayIpc.Persistence.{PublishedMessage, ConsumedMessage}

  @callback get_consumed_messages() :: [ConsumedMessage.t()]
  @callback published_messages_count() :: Integer.t()
  @callback get_published_messages(params :: Map.t()) :: [PublishedMessage.t()]
  @callback search_published_messages(query_filter :: String.t(), query_value :: String.t()) :: [PublishedMessage.t()]
end
