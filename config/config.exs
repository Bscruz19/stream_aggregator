use Mix.Config

config :stream_aggregator,
  notification_time: 6_000,
  web_port: System.get_env("PORT") || "1234"

import_config "#{Mix.env()}.exs"
