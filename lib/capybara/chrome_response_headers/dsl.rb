module Capybara::ChromeResponseHeaders::DSL
  [
    :request_for_url,
    :response_for_url,
    :current_host_with_port,
  ].each do |method|
    define_method method do |*args, &block|
      page.send method, *args, &block
    end
  end
end
