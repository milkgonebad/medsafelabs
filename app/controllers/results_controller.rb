class ResultsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_test, only: [:show]
  
  # this is the url that we'll put in the email with results
  def show
  end

  def index
    if params[:order_id].present?
      @tests = current_user.tests.where(order_id: params[:order_id]).order(updated_at: :desc)
    else  
      @tests = current_user.tests.order(updated_at: :desc)
    end
    @customer = current_user
  end
  
  private
  
  def set_test
    if current_user.admin?
      test = Test.find(params[:id])
      redirect_to user_test_path(test.user, test) and return
    end
    test = current_user.tests.where(id: params[:id])
    @customer = current_user
    if test.empty?
      flash[:error] = "I can't find your test with this number:  " + params[:id]
      redirect_to '/dashboard' and return
    else
      @test = test.first
    end
  end
  
  def results_params
    params.require(:id, :order_id)
  end
  
end
