defmodule RailwayUi.ConsumedMessage do
  @persistence Application.get_env(:railway_ui, :persistence)

  def all do
    @persistence.get_consumed_messages()
  end
end
