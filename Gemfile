source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
#gem 'capistrano', group: :development
gem 'capistrano-rails', group: :development


# Use debugger
# gem 'debugger', group: [:development, :test]



# Let's use RSpec for testing, instead of unit-test --PJR
group :development, :test do
	gem 'rspec-rails'
end

# For ActiveAdmin:
#gem 'activeadmin', github: 'gregbell/active_admin'  # special github so it'll work with Rails 4.  Periodically check if still necessary.
#gem 'activeadmin', '= 0.5.1'
gem 'activeadmin', git:  'https://github.com/gregbell/active_admin.git'  # special github so it'll work with Rails 4.  Periodically check if still necessary.

gem 'devise'

gem 'thin'

#group :development do
	gem 'better_errors'
	gem 'binding_of_caller'
#end


# For global settings: --PJR
gem "rails-settings-cached", "0.3.1"


# for HAML!
gem "haml"

gem 'exifr'

gem 'bullet', group: "development"

gem 'delayed_job_active_record'

#gem 'sql-logging'
gem 'active-record-query-trace'


# This is for history.js:
gem 'historyjs-rails'


gem 'jquery-ui-rails'


gem 'pry', group: :development
gem 'pry-rails', group: :development
gem 'pry-nav', group: :development

gem 'awesome_print'
