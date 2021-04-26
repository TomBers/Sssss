import Config

secret_key = System.get_env("SECRET_KEY_BASE")

config :sssss, SssssWeb.Endpoint,
       secret_key_base: secret_key
