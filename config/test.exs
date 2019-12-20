use Mix.Config

# Configure your database
config :data_merge, DataMerge.Repo,
  username: "postgres",
  password: "postgres",
  database: "data_merge_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :data_merge, DataMergeWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
