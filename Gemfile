# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.3.4'

# gem 'active_fulfillment', path: '/Users/ryan/dev/active_fulfillment'
gem 'active_fulfillment', git: 'https://github.com/ryanfreeth/active_fulfillment', :branch => 'master'

gem 'omniauth-shopify-oauth2', '~> 1.1.8'
gem 'shopify-sinatra-app', '~> 0.1.0'
gem 'shopify_api', '~> 4.3.0'

gem 'foreman'
gem 'rake'

group :production do
  gem 'pg'
end

group :development do
  gem 'byebug'
  gem 'fakeweb'
  gem 'mocha', require: false
  gem 'pry'
  gem 'rack-test'
  gem 'test-unit'
  gem 'sqlite3'
end
