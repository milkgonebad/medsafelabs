class QrController < ApplicationController
  before_filter :authenticate_user!, :ensure_admin, :validate_qr
  
  def index
    @test = Test.find_by qr_code_number: params[:id]
    if @test.nil?
      @qr = Qr.available.find_by qr_code_number: params[:id]
      if @qr.nil?
        flash[:error] = "This QR code '" + params[:id] + "' is not in our system or has already been used."
        redirect_to '/dashboard' and return
      end
    
      # ok valid new qr code - do we have a customer
      if session[:customer_id].blank?
        # TODO:  we should give a way to look up customers but for now tough luck
        flash[:error] = "Please select a customer to work with and scan this QR code again."
        redirect_to users_path and return
      end
      
      # does this customer have any unassociated tests?
      @customer = User.find(session[:customer_id])
      tests = @customer.tests.no_qr_code
      if tests.empty?
        flash[:error] = "This customer doesn't have any tests available.  Please create an order then rescan this code."
        redirect_to user_orders_path(@customer) and return
      end
      
      # ok, we have a customer, a good qr code, and available tests
      # push all of this good stuff to the tests controller and it can do the rest
      flash[:notice] = "Associating this QR code with a new test!"
      redirect_to edit_user_test_path(@customer, tests.first, qr_code_number: params[:id]) and return
    else
      # in this case we don't need the customer number which is ok!  Go right to the test since we will start testing!
      # TODO does this set the receive status? or in progress?  I think we need some shiny buttons on the show page
      flash[:notice] = "Test retrieved by your QR code."
      redirect_to user_test_path(@test.user_id, @test) and return
    end
  end
  
  private
  
  def qr_params
    params.require(:id)
  end
  
  def validate_qr
    unless params[:id] =~ /\A\d+\z/
      flash[:error] = "Invalid QR code."
      redirect_to '/'
    end
  end
  
end