class ResultsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_test, only: [:show]
  
  # this is the url that we'll put in the email with results
  def show
    render 'tests/show'
  end

  def index
    @tests = current_user.tests
  end
  
  private
  
  def set_test
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
    params.require(:id)
  end
  
end
