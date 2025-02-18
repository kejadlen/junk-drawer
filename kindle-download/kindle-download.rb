#!/usr/bin/env ruby

require "logger"
require "net/http"

require "capybara/cuprite"
Capybara.javascript_driver = :cuprite
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, headless: false)
end
Capybara.current_driver = :cuprite

require "capybara/dsl"
original_verbosity = $VERBOSE
$VERBOSE = nil
include Capybara::DSL
$VERBOSE = original_verbosity

Book = Data.define(:id, :title)

AMAZON_EMAIL = ENV.fetch("AMAZON_EMAIL")
AMAZON_PASSWORD = ENV.fetch("AMAZON_PASSWORD")

def wait_for_download
  already_downloaded = Dir[File.expand_path("~/Downloads/*.azw*")]
  yield
  loop do
    current = Dir[File.expand_path("~/Downloads/*.azw*")]
    new_book, *rest = current - already_downloaded
    if new_book.nil?
      sleep 0.1
    else
      fail unless rest.empty?
      return new_book
    end
  end

end

log = Logger.new(STDOUT)

url = "https://www.amazon.com/hz/mycd/digital-console/contentlist/booksPurchases/dateDsc"
visit url

fill_in "email", with: AMAZON_EMAIL
fill_in "password", with: AMAZON_PASSWORD
find("#signInSubmit").click

fill_in "otpCode", with: `op item get --otp ngcal7ifttkh4lbd5ww6slde4q`
click_on "mfaSubmit"

files = Dir[File.expand_path("~/Downloads/*.azw*")]
ids = files.map {
  `xattr -p com.apple.metadata:kMDItemWhereFroms "#{it}"`.chomp
}
log.info("Already downloaded: #{files.zip(ids)}")

(1..11).each do |page_number|
  url = "https://www.amazon.com/hz/mycd/digital-console/contentlist/booksPurchases/dateDsc?pageNumber=#{page_number}"
  visit url

  books = all(".digital_entity_title").map {
    Book.new(id: it["id"].split(?-).last, title: it.text)
  }.map.with_index.reject {|book, _| ids.include?(book.id) }

  log.info("Downloading: #{books.map(&:first).map(&:title)}")

  books.each do |book, i|
    more_actions, kindle, download = all(:xpath, "//span[text()='More actions']").zip(
      all(:xpath, "//input[@name='actionListRadioButton']", visible: false),
      all(
        :xpath,
        "//div[starts-with(@id, 'DOWNLOAD_AND_TRANSFER_ACTION_') and contains(@id, '_CONFIRM')]",
        visible: false,
      ),
    ).fetch(i)

    more_actions.base.node.scroll_into_view
    more_actions.click
    find(:xpath, "//span[text()='Download & transfer via USB']").click
    kindle.click

    log.info("Downloading #{book.title} (#{book.id})")

    downloaded = wait_for_download { download.click }
    `xattr -w com.apple.metadata:kMDItemWhereFroms #{book.id} "#{downloaded}"`

    find("#notification-close").click
  end
end
