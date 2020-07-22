#!/usr/bin/env ruby

# require "bundler/inline"

# gemfile do
#   source "https://rubygems.org"
#   gem "capybara"
# end

require "bundler/setup"

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

suppress_warnings do
  visit "https://pinboard.in"
end

fill_in "username", with: ENV.fetch("PINBOARD_USERNAME")
fill_in "password", with: ENV.fetch("PINBOARD_PASSWORD")
click_button "log in"

visit "https://pinboard.in/u:kejadlen/code:500"

all(:xpath, "//a[@title='Click to re-crawl this link']").each do |link|
  link.click
end
