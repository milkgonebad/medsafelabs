class TestsController < ApplicationController
  before_filter :authenticate_user!, :ensure_admin
  before_filter :ensure_super_admin, only: [:destroy]
  before_action :set_test, only: [:show, :edit, :update, :destroy]
  before_action :set_customer
  before_filter :check_qr_code, only: [:update]

  def index
    # filter by user or by order... at least for now
    filter = params[:order_id] ? {order_id: params[:order_id]} : {user: @customer}
    @tests = Test.where(filter)
  end

  def show
  end

  def edit
    # redirect to the show page if the test is complete - or is not received and we don't have a qr code
    if (@test.complete? and !current_user.super_admin?) or (@test.not_received? and params[:qr_code].nil?)
      redirect_to :action => :show and return
    end
    if params[:qr_code] and @test.qr.nil?
      @test.qr_id = Qr.available.find_by!(qr_code: params[:qr_code]).id
      @has_qr = true
    end
  end

  def update
    update_params = test_params
    current_status = @test.status
    update_params.merge!(status: @test.next_status) if params[:update_status] # only do this when the button is clicked
    update_params.merge!(updated_by: current_user)
    respond_to do |format|
      if @test.update(update_params)
        if @test.in_progress? or @test.received?
          format.html { redirect_to edit_user_test_path(@customer, @test), notice: 'Test was successfully updated.' }
        else
          format.html { redirect_to user_test_path(@customer, @test), notice: 'Test was successfully updated.' }
        end
        format.json { head :no_content }
      else
        @test.status = current_status
        @has_qr = true if @test.qr_id
        format.html { render action: 'edit' }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  #FIXME not sure if we'll ever destroy a test...  Perhaps super admin chicken can do it?
  def destroy 
    if @test.destroy
      redirect_to user_tests, notice: 'Test was successfully destroyed.'
    else
      redirect_to user_tests, alert: 'Test was not successfully destroyed.'
    end
  end
  
  def scan
  end

  private
  
    def check_qr_code
      if params.include? :qr_code          
        @qr = Qr.available.find_by qr_code: params[:qr_code]
        flash[:error] = "This QR code '" + params[:qr_code] + "' is not in our system or has already been used."
        redirect_to :edit and return
      end
    end
  
    def set_test
      @test = Test.find(params[:id])
    end
    
    def set_customer
      @customer = User.find(params[:user_id].to_i)
      session[:customer_id] = @customer.id
    end

    def test_params
      params.require(:test).permit(
        :status, :strain_id, :new_strain, :notes, :qr_id, :sample_type, :cbd, 
        :cbn, :thc, :thcv, :cbg, :cbc, :thca, :plate, :update_status, :sample)
    end

end