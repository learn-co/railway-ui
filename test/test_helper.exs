{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(RailwayUi.Repo, :manual)
Application.ensure_all_started(:mox)
