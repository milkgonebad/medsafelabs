class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :store_location
  before_filter :configure_permitted_parameters, if: :devise_controller?
  
  def after_sign_in_path_for(resource)
    session[:previous_url] || '/dashboard'
  end
  
  def after_sign_out_path_for(resource)
    new_user_session_path
  end
  
  def after_update_path_for(resource)
    session[:previous_url] || '/dashboard'
  end
  
  private
  
  def ensure_admin
    unless current_user.admin?
      flash[:error] = 'You are not authorized to edit users.'
      redirect_to root_path
    end 
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name, :email, :address1, :address2, :city, :state, :country,
        :registration_number, :control_number, :issued_on, :expires_on]
  end
  
  def store_location
    if (!request.fullpath.match("/users/") && !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end
  
end
