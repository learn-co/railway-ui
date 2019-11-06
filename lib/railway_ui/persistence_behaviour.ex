defmodule RailwayUi.PersistenceBehaviour do
  @moduledoc false
  alias RailwayIpc.Persistence.{PublishedMessage, ConsumedMessage}

  @callback get_consumed_messages() :: [ConsumedMessage.t()]
  @callback get_published_messages() :: [PublishedMessage.t()]
end
