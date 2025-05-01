source "https://rubygems.org"

ENV["DB"] ||= "postgresql"

branch = ENV.fetch('SOLIDUS_BRANCH', 'main')
gem "solidus_core", "~> 3.2.0"
gem "solidus_api", "~> 3.2.0"
gem "solidus_backend", "~> 3.2.0"

gem "rails", "~> 7.0.0"

gem "rails-controller-testing", group: :test
gem "active_shipping", github: "pervino/active_shipping", branch: "update-active-support"

# This can be removed after Rails 7.1+
# https://stackoverflow.com/questions/79360526/uninitialized-constant-activesupportloggerthreadsafelevellogger-nameerror
gem 'concurrent-ruby', '1.3.4'

gem 'pg'
gem "factory_bot_rails"
gem "pry-rails"
gem "ffaker"
gem "puma"
gem "capybara", "~> 3.0"
gem "selenium-webdriver"
gem "coffee-rails"

gemspec

gem "solidus_frontend", "~> 4.0"
