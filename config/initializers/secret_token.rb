# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Scheduler::Application.config.secret_key_base = 'b13ed250f98568d8d9f7b28eda5ea9b0f62a82f32db4c381659f41c48752cf8a43305cab58cb1c1ec9d84ee43a0f5f04c0d0e4ba79475699c64475d201ea7125'
