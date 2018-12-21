lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "capybara/chrome_response_headers/version"

Gem::Specification.new do |spec|
  spec.name          = "capybara-chrome_response_headers"
  spec.version       = Capybara::ChromeResponseHeaders.version
  spec.authors       = ["Tyler Rick"]
  spec.email         = ["tyler@tylerrick.com"]
  spec.license       = "MIT"

  spec.summary       = %q{Allows you to get HTTP status_code, response_headers, etc. when using Capybara::Selenium::Driver just like you can when using Rack::Test}
  #spec.description   = %q{}
  spec.homepage      = "https://github.com/TylerRick/capybara-chrome_response_headers"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.metadata["source_code_uri"]}/blob/master/Changelog.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3.0"
  spec.add_dependency "capybara-chrome_dev_tools", [">= 0.2"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
