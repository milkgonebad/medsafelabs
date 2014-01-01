class DashboardController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    if current_user.admin?
      admin_view
    else
       customer_view
    end
  end

  def customer_view
    @not_received = current_user.tests.not_received
    @received = current_user.tests.received
    @in_progress = current_user.tests.in_progress
    @complete = current_user.tests.complete
    render 'customer_view'
  end
  
  def admin_view
    render 'index'
  end
  
end
