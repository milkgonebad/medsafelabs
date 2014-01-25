# manages the user's purchase history - admins should use orders - they're the same thing - different ways to get there :)
class PurchasesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_order, only: [:show]
  before_action :set_customer, only: [:show, :index]
  
  # this is the url that we'll put in the email with results
  def show
    render 'orders/show'
  end

  def index
    @orders = current_user.orders
    @customer = current_user
  end
  
  private
  
  def set_order
   @order = Order.find(params[:id])
  end
  
  def set_customer
    @customer = current_user
  end
  
  def orders_params
    params.require(:id)
  end
  
end
