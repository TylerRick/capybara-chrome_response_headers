# Capybara::ChromeResponseHeaders

Allows you to get HTTP status_code, response_headers, etc. when using Capybara::Selenium::Driver
just like you can when using Rack::Test.

The [Capybara docs]()https://github.com/teamcapybara/capybara) say:

> Some drivers allow access to response headers and HTTP status code, but this kind of functionality is not provided by some drivers, such as Selenium.

But with this gem, you can have it for your Chrome Selenium driver, too!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capybara-chrome_response_headers'
```

## Usage

Inspect `status_code` or `response_headers` in your tests to get the HTTP status code or headers,
respectively, for the current URL (the web page that you last visited or were redirected to).

You can access the `response` information for other assets using `response_for_url`.

Example:

```ruby
      it do
        visit '/test/test_redirect?to=/test/basic_page%3Fmy_param=1'
        expect_uri '/test/basic_page?my_param=1'

        # Since it automatically follows redirects, you can't check if it was a redirect using this
        expect(status_code).to eq 200

        expect(response_headers["Content-Type"]).to eq "text/html; charset=utf-8"
        expect(response_headers.keys).to include *["Content-Type", "ETag", "Cache-Control", "Set-Cookie", "X-Meta-Request-Version", "X-Request-Id", "X-Runtime", "X-Frame-Options", "X-Content-Type-Options", "X-XSS-Protection", "Referrer-Policy", "Content-Security-Policy", "Transfer-Encoding"]

        # Could do the same for asset paths, like response_for_url["#{current_host_with_port}/asset/logo.png"]
        expect(response_for_url["#{current_host_with_port}/users/sign_in"].status).to eq 200
        expect(response_for_url["#{current_host_with_port}/users/sign_in"].headers).to be_a Hash
      end
```

## Tracing

To have it show a trace of all requests and/or responses that are made from the web pages you are interacting with, enable these settings, respectively:

```
Capybara::ChromeResponseHeaders.trace_requests  = true
Capybara::ChromeResponseHeaders.trace_responses = true
```

The output for responses is something like this:
```
Response for http://127.0.0.1:40359/users/sign_in: 200 OK
Response for http://127.0.0.1:40359/admin: 200 OK
```

By default, it tries to filter out requests for assets. (`Capybara::ChromeResponseHeaders.ignore_urls` is set to `/\.(js|css|png|gif|jpg)$/`.)

You can turn off this filtering by setting `Capybara::ChromeResponseHeaders.ignore_urls = nil`, or
set it to a different Regexp pattern to ignore.

If you want other behavior to happen on each request or response, you should be able to add it via `dev_tools` (a [ChromeRemote]((https://github.com/cavalle/chrome_remote) instance):

```ruby
      dev_tools.on "Network.requestWillBeSent" do |arg|
        request = OpenStruct.new(arg["request"])
        puts "Requesting #{request.url}"
      end

      dev_tools.on "Network.responseReceived" do |arg|
        response = OpenStruct.new(arg["response"])
        puts %(Response for #{response.url}"
      end
```

## Why?

Because it can be useful to be able to check the HTTP status code in tests.  Many people have wanted
that ability. And the WebDriver maintainers have no intention of adding this feature. See, for
example:

- https://github.com/seleniumhq/selenium-google-code-issue-archive/issues/141
- https://github.com/SeleniumHQ/selenium/issues/4976
- https://github.com/SeleniumHQ/selenium/issues/5194
- https://groups.google.com/forum/#!msg/selenium-users/mlwxk0jKYtM/gc1ZBwZIRuEJ;context-place=searchin/selenium-users/get$20HTTP$20status$20code%7Csort:date
- https://stackoverflow.com/questions/6509628/how-to-get-http-response-code-using-selenium-webdriver

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/TylerRick/capybara-chrome_response_headers.
