defmodule DataMerge.Repo do
  use Ecto.Repo,
    otp_app: :data_merge,
    adapter: Ecto.Adapters.Postgres
end
