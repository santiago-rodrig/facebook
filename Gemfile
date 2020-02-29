source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Or use postgres instead
gem 'pg'
# Use this gem to hide stuffs
gem 'dotenv-rails'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# Use devise for authentication
gem 'devise'
# Use facebook omniauth
gem 'omniauth-facebook'
# Use bootstrap 3
gem 'bootstrap-sass', '~> 3.4.1'
gem 'jquery-rails'
# Nice tabular formatting in console
gem 'hirb'
# Rubocop for ruby code styling linting
gem 'rubocop'
# Faker for populating the database with fake data
gem 'faker', git: 'https://github.com/faker-ruby/faker.git', branch: 'master'
# Pagination with bootstrap
gem 'will_paginate', '~> 3.1.0'
gem 'will_paginate-bootstrap'
# Concurrency
gem 'concurrent-ruby', '1.1.5'
# gem 'concurrent-ruby', git: 'https://github.com/ruby-concurrency/concurrent-ruby.git', branch: 'master'
# nokogiri for view specs
gem 'nokogiri', '1.10.5'

group :development, :test do
  gem 'database_cleaner' # clean the database after each example
  gem 'rspec-rails' # tests that use RSpec
  # populate the test database when running tests
  gem 'factory_bot_rails', git: 'http://github.com/thoughtbot/factory_bot_rails.git', branch: 'master'
end

group :development do
  # debugging with byebug controller actions
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # automated testing with guard using rspec
  # gem 'guard'
  gem 'guard-rspec', require: false
end

group :test do
  gem 'capybara', '~> 2.13' # feature testing with a browser
  gem 'rails-controller-testing' # use the assigns(:varname) in tests
  gem 'selenium-webdriver' # use a browser for testing
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
