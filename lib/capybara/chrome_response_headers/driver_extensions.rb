module Capybara::ChromeResponseHeaders
  module DriverExtensions
    attr_reader :listening_to_network_traffic
    attr_reader :listener_thread

    attr_reader :request_for_url
    attr_reader :response_for_url

    def initialize(*)
      super
      @request_for_url  = {}
      @response_for_url = {}
    end

    def browser
      super.tap do |browser|
        if Capybara::ChromeDevTools.enabled and !@listening_to_network_traffic
          listen_to_network_traffic
        end
      end
    end

    def listen_to_network_traffic
      @listening_to_network_traffic = true
      chrome = dev_tools
      chrome.send_cmd "Network.enable"

      chrome.on "Network.requestWillBeSent" do |arg|
        request = OpenStruct.new(arg["request"])
        next if Capybara::ChromeResponseHeaders.ignore_urls && request.url.match(Capybara::ChromeResponseHeaders.ignore_urls)

        @request_for_url[request.url] = request
        puts "Requesting #{request.url}" if Capybara::ChromeResponseHeaders.verbose
      end

      chrome.on "Network.responseReceived" do |arg|
        response = OpenStruct.new(arg["response"])
        next if Capybara::ChromeResponseHeaders.ignore_urls && response.url.match(Capybara::ChromeResponseHeaders.ignore_urls)

        # TODO: Use/return a Rack::Response like Rack::Test does
        @response_for_url[response.url] = response
        puts %(Response for #{response.url}: #{response.status} #{response.statusText}) if Capybara::ChromeResponseHeaders.verbose
      end

      @listener_thread = Thread.new do
        chrome.listen
        @listening_to_network_traffic = false
      end
    end

    def request
      #@request_for_url[current_url] or byebug
      @request_for_url[current_url]
    end

    def response
      #@response_for_url[current_url] or byebug
      @response_for_url[current_url]
    end

    def response_headers
      response&.headers
    end

    def status_code
      response&.status
    end

    def status_text
      response&.statusText
    end
  end
end
