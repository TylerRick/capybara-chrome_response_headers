require "capybara/chrome_response_headers/version"

module Capybara::ChromeResponseHeaders
  autoload :DriverExtensions, 'capybara/chrome_response_headers/driver_extensions'
  autoload :DSL,              'capybara/chrome_response_headers/dsl'

  class << self
    attr_accessor :verbose
    attr_accessor :ignore_urls
  end
  self.verbose = nil
  # The default is to try to ignore asset files so that hopefully what's left is just HTML/API
  # requests.
  self.ignore_urls = /\.(js|css|png|gif|jpg)$/
end

Capybara::Selenium::Driver.class_eval do
  prepend Capybara::ChromeResponseHeaders::DriverExtensions
end

Capybara::Session.class_eval do
  ##
  # Returns a client for the browser's dev tools protocol. Not supported by all drivers.
  def status_text
    driver.status_text
  end

  # Can't call it request_for because that conflicts with a method by that name in
  # selenium/webdriver/remote/http/default.rb
  def request_for_url
    driver.request_for_url
  end

  def response_for_url
    driver.response_for_url
  end

  # For some reason, current_host includes scheme and host but not port
  def current_host_with_port
    uri = URI.parse(current_url)
    "#{uri.scheme}://#{uri.host}:#{uri.port}"
  end

end

module Capybara::DSL
  include Capybara::ChromeResponseHeaders::DSL
end
