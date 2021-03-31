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

# require "csv"
# csv = CSV.new(File.new("goodreads_library_export.csv"), headers: true)
# authors = csv
#   .select {|row| row.fetch("My Rating").to_i >= 4 }
#   .group_by {|row| row.fetch("Author") }
#   .keys

authors = ARGF.read.split("\n")

require "capybara"
Capybara.default_driver = :selenium

require "selenium/webdriver"
Selenium::WebDriver::Firefox::Binary.path = "/Applications/Firefox\ Developer\ Edition.app/Contents/MacOS/firefox"

require "capybara/dsl"
suppress_warnings do
  include Capybara::DSL
end

suppress_warnings do
  visit "http://bookfeed.io/"
end

click_button "Make my Feed"

authors.each do |author|
  fill_in "addAuthorField", with: author
  click_button "Add Author"
end

puts find_by_id("feedUrl")["value"]
