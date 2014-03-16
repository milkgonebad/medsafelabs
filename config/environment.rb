# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
MedSafeLabs::Application.initialize!

# if ENV['MAILTRAP_HOST'].present?
    # ActionMailer::Base.smtp_settings = {
      # :user_name => ENV['MAILTRAP_USER_NAME'],
      # :password => ENV['MAILTRAP_PASSWORD'],
      # :address => ENV['MAILTRAP_HOST'],
      # :port => ENV['MAILTRAP_PORT'],
      # :authentication => :plain
  # }
# else
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
  }
# end