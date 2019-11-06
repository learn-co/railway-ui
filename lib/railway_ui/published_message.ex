defmodule RailwayUi.PublishedMessage do
  @persistence Application.get_env(:railway_ui, :persistence)

  def all do
    @persistence.get_published_messages()
  end
end
