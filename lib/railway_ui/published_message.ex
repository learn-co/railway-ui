defmodule RailwayUi.PublishedMessage do
  @persistence Application.get_env(:railway_ui, :persistence, RailwayUi.Persistence)
  @limit 2
  @page "1"

  def all(page \\ @page) do
    @persistence.get_published_messages(%{limit: @limit, page: page})
  end

  def page_nums do
    (@persistence.published_messages_count() / @limit)
    |> Float.ceil()
    |> Kernel.trunc()
  end
end
