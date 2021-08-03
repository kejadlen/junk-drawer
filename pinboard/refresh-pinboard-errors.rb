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
require "selenium/webdriver"

remote_host = ENV.fetch("REMOTE_SELENIUM_HOST", "localhost:4444")
Capybara.register_driver :remote do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: "http://localhost:4444/wd/hub",
    desired_capabilities: :firefox,
  )
end
Capybara.default_driver = :remote

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

[ 400, 429, 500 ].each do |error_code|
  visit "https://pinboard.in/u:kejadlen/code:#{error_code}"

  all(:xpath, "//a[@title='Click to re-crawl this link']").each do |link|
    bookmark = link.find(:xpath, "../a[starts-with(@class, 'bookmark_title')]")
    puts "Re-crawling #{bookmark.text}"
    link.click
  end
end
