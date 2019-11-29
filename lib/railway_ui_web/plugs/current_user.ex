defmodule RailwayUiWeb.CurrentUser do
  @moduledoc false

  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn
    |> put_session(:current_user_uuid, "1f4c4051-fe12-41cf-a39a-49f794f6b333")
  end
end
