#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "capybara"
  gem "pry"
  gem "selenium-webdriver"
end

def suppress_warnings
  original_verbosity = $VERBOSE
  $VERBOSE = nil
  yield
  $VERBOSE = original_verbosity
end

require "capybara"
Capybara.default_driver = :selenium

require "selenium/webdriver"
Selenium::WebDriver::Firefox::Binary.path = "/Applications/Firefox\ Developer\ Edition.app/Contents/MacOS/firefox"

require "capybara/dsl"
suppress_warnings do
  include Capybara::DSL
end

logger = Logger.new(STDOUT)
logger.level = Logger::INFO

url = "https://seattle.signetic.com/home"
suppress_warnings do
  loop do
    logger.info("Checking...")
    visit url

    break unless page.has_content?("No appointments available")

    sleep 5*60
  end
end

twilio_sid = ENV.fetch("TWILIO_SID")
twilio_token = ENV.fetch("TWILIO_TOKEN")
twilio_from = ENV.fetch("TWILIO_FROM")
twilio_to = ENV.fetch("TWILIO_TO")
`curl -X POST https://api.twilio.com/2010-04-01/Accounts/#{twilio_sid}/Messages.json \
  --data-urlencode "Body=#{url}" \
  --data-urlencode "From=+#{twilio_from}" \
  --data-urlencode "To=+#{twilio_to}" \
  -u $TWILIO_SID:$TWILIO_TOKEN`
