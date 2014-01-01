class HomeController < ApplicationController
  before_filter :go_to_dashboard
  
  def index
  end
  
  private
  
  def go_to_dashboard
    if user_signed_in?
      redirect_to '/dashboard' and return
    end
  end
  
end