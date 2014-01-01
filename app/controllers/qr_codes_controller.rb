class QrCodesController < ApplicationController
  before_filter :authenticate_user!, :ensure_admin

  def index
    @qr = Qr.available.first
  end
  
  def show
    @qrurl = Qr.find(params[:id]).generate
    respond_to do |format|
      format.html
      #format.svg  { render :qrcode => @qrurl, :level => :l, :unit => 10 }
      format.png  { render :qrcode => @qrurl }
      format.gif  { render :qrcode => @qrurl }
      format.jpeg { render :qrcode => @qrurl }
    end
  end
  
  def import
    num_created, num_exists = Qr.import(params[:file]) 
    flash[:notice] = "Results of QR Code Import:  " + num_created.to_s + " created, " + num_exists.to_s + " already existed."
    redirect_to :action => :index and return
  end

  private

  def qr_code_params
    params[:qr_code].permit(:file)
  end
  
end
