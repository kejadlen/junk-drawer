#!/usr/bin/env ruby

require "json"

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "faraday"
  # gem "faraday_middleware"
  gem "pry"
end

# resp = Faraday.get(
#   "https://api.pinboard.in/v2/bookmarks",
#   { tags: %w[ paper pair_programming ] },
#   {
#     "X-App-ID" => ENV.fetch("PINBOARD_APP_ID"),
#     "X-Auth-Token" => ENV.fetch("PINBOARD_AUTH_TOKEN"),
#   },
# )

resp = Faraday.get(
  "https://api.pinboard.in/v1/posts/all",
  {
    auth_token: ENV.fetch("PINBOARD_AUTH_TOKEN"),
    format: "json",
    tag: "paper,pair_programming",
  },
)

json = JSON.parse(resp.body)
require "pry"; binding.pry
