# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :data_merge,
  ecto_repos: [DataMerge.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :data_merge, DataMergeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Djnev/9BTF+8iudqZyj718Bln2m65AEmqCpHWD1qD+FrRQ3RkGTuqEaXsNICWWKK",
  render_errors: [view: DataMergeWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: DataMerge.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
