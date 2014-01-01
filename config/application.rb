require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module OldPort
  class Application < Rails::Application
    # set the sessions controller to use a different layout
    config.to_prepare do
      Devise::SessionsController.layout "home"
      Devise::RegistrationsController.layout proc{ |controller| user_signed_in? ? "application" : "home" }
      Devise::ConfirmationsController.layout "home"
      Devise::UnlocksController.layout "home"            
      Devise::PasswordsController.layout "home" 
    end
    
  end
end
