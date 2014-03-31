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
  
  def after_accept_path_for(resource)
    '/dashboard'
  end
  
  private
  
  def ensure_admin
    unless current_user.admin?
      set_flash
      redirect_to :back
    end 
  end
  
  def ensure_super_admin
    unless current_user.super_admin?
      set_flash
      redirect_to :back
    end 
  end
  
  def ensure_can_run_tests
    unless current_user.can_run_tests?
      set_flash
      redirect_to :back
    end 
  end
  
  def ensure_can_manage_customers
    unless current_user.can_manage_customers?
      set_flash
      redirect_to :back
    end 
  end
  
  def set_flash
    flash[:error] = 'You are not authorized to perform this action.'
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name, :email, :address1, :address2, :city, :state, :postal_code,
        :registration_number, :control_number, :expires_on, :terms, :ccm_handle, :publish, :terms]
    devise_parameter_sanitizer.for(:sign_up) << [:terms]
  end
  
  def store_location
    if (!request.fullpath.match("/users/") && !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end
  
end
