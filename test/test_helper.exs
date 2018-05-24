{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start

{:ok, _pid} = Dummy.Repo.start_link
Ecto.Adapters.SQL.Sandbox.mode(Dummy.Repo, :manual)
