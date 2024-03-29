#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "capybara"
  gem "pry"
  # gem "selenium-webdriver"
  gem "cuprite"
end

def suppress_warnings
  original_verbosity = $VERBOSE
  $VERBOSE = nil
  yield
  $VERBOSE = original_verbosity
end

require "capybara/cuprite"

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app)
end
Capybara.default_driver = :cuprite

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

[ 400, 404, 429, 500 ].each do |error_code|
  puts "Checking error code #{error_code}"
  visit "https://pinboard.in/u:kejadlen/code:#{error_code}"

  # TODO: Try text()='↺' instead?
  all(:xpath, "//a[@title='Click to re-crawl this link']").each do |link|
    bookmark = link.find(:xpath, "../a[starts-with(@class, 'bookmark_title')]")
    puts "Re-crawling #{bookmark.text}"
    link.click
  end
end
