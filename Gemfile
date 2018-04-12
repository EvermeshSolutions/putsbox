source 'https://rubygems.org'

ruby '2.5.0'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.0'

# Use SCSS for stylesheets
gem 'sass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'mongoid', '~> 6'
gem 'kaminari-mongoid'
gem 'kaminari-actionview'
gem 'redis'

gem 'bootstrap-sass', '~> 3.1.1'

group :production do
  gem 'unicorn'
  gem 'rails_12factor'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'capybara'
  gem 'poltergeist'
  gem 'stub_env'
  gem 'rails-controller-testing'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'rack-test'
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'webmock'
end

source 'https://rails-assets.org' do
  gem 'rails-assets-clipboard'
  gem 'rails-assets-favico.js'
  gem 'rails-assets-dispatcher'
  gem 'rails-assets-bootstrap-less'
end

gem 'dotiw'
gem 'devise'
gem 'pusher'
gem 'interactor', '~> 3.0'
gem 'active_model_serializers'
gem 'faker'
gem 'react-rails'
gem 'staccato'
gem 'rollbar'
gem 'oj'
gem 'loofah', '~> 2.2.1'
