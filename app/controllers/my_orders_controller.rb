class MyOrdersController < ApplicationController
 
  before_filter :authenticate_user!
  before_action :set_order, only: [:show]

  def index
    @orders = Order.where(:user => current_user).order(created_at: :desc)
  end

  def show
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:memo, :payment_type, :quantity, :total)
    end

end
