class OrdersController < ApplicationController
 
  before_filter :authenticate_user!, :ensure_admin
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_customer

  def index
    @orders = Order.where(:user => @customer)
  end

  def show
  end

  def new
    @order = Order.new
    @order.set_defaults
  end

  def edit
  end

  def create
    @order = @customer.orders.new(order_params)
    @order.creator = current_user
    respond_to do |format|
      if @order.save
        format.html { redirect_to user_order_path(@customer, @order), notice: 'Order was successfully created.' }
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { render action: 'new', alert:  @order.errors.inspect }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to user_order_path(@customer, @order), notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @order.destroy
      redirect_to user_orders, notice: 'Order was successfully destroyed.'
    else
      redirect_to user_orders, alert: 'Order was not successfully destroyed.'
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end
    
    def set_customer
      @customer = User.find(params[:user_id].to_i)
      session[:customer_id] = @customer.id
    end

    def order_params
      params.require(:order).permit(:memo, :payment_type, :quantity, :total)
    end

end
