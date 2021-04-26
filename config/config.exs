# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :sssss, SssssWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RBgmgDDhvnYmgGOeevXDLOmMWVKqPp4S941iyXc2yW3c5jWlVngppSTW+aPyyo79",
  render_errors: [view: SssssWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Sssss.PubSub,
  live_view: [signing_salt: "q5Qr02Qq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


config :wallaby, driver: Wallaby.Chrome
config :wallaby, otp_app: :sssss
config :wallaby,
       chromedriver: [
         path: "/node_modules/chromedriver/bin/chromedriver",
         capabilities:   %{
           javascriptEnabled: true,
           loadImages: true,
           version: "",
           rotatable: false,
           takesScreenshot: true,
           cssSelectorsEnabled: true,
           nativeEvents: false,
           platform: "ANY",
           unhandledPromptBehavior: "accept",
           loggingPrefs: %{
             browser: "DEBUG"
           },
           chromeOptions: %{
             args: [
               "--no-sandbox",
               "window-size=1920,1080",
               "--disable-gpu",
               "--headless",
               "--fullscreen",
               "--user-agent=Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
             ]
           }
         }
       ]

config :waffle,
       storage: Waffle.Storage.S3, # or Waffle.Storage.Local
       bucket: System.get_env("AWS_BUCKET_NAME") # if using S3

# If using S3:
config :ex_aws,
       json_codec: Jason,
       access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
       secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
       region: System.get_env("AWS_REGION")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
