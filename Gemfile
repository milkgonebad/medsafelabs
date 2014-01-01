source 'https://rubygems.org'

gem 'rails', '> 4.0'
gem 'pg'
gem 'jquery-rails'
gem 'turbolinks'
gem 'devise'
gem 'devise_invitable'
#gem 'devise_security_extension' # does not work in rails 4 yet https://github.com/phatworx/devise_security_extension
gem 'rails_email_validator'
gem 'paperclip'
gem 'aws-sdk'
gem 'exception_notification'
gem 'rqrcode-rails3'
gem 'mini_magick'

# these probably should be in the assets group - development isn't happy without them though for some reason
gem "less-rails"
gem 'twitter-bootstrap-rails'
gem 'therubyracer'
gem 'simple_form'
gem 'country_select'

group :assets do
  gem 'sass-rails' 
  gem 'uglifier'
  gem 'coffee-rails'
end

group :development do
  gem 'debugger'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'cucumber'
  gem 'cucumber-rails', :require => false
  gem 'quiet_assets'
end

group :test do
  gem 'debugger'
  gem 'rspec-rails'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'poltergeist'
end

group :production do
  gem 'rails_12factor'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

ruby '2.0.0'