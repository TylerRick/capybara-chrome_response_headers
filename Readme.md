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

## Why?

Because it's useful to be able to check the HTTP status code, and many people have wanted that
ability, and because the WebDriver maintainers have no intention of adding this feature:

- https://github.com/seleniumhq/selenium-google-code-issue-archive/issues/141
- https://github.com/SeleniumHQ/selenium/issues/4976
- https://github.com/SeleniumHQ/selenium/issues/5194
- https://groups.google.com/forum/#!msg/selenium-users/mlwxk0jKYtM/gc1ZBwZIRuEJ;context-place=searchin/selenium-users/get$20HTTP$20status$20code%7Csort:date
- https://stackoverflow.com/questions/6509628/how-to-get-http-response-code-using-selenium-webdriver

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/TylerRick/capybara-chrome_response_headers.
