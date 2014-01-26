class QrCodesController < ApplicationController
  before_filter :authenticate_user!, :ensure_admin

  def index
    @qr = Qr.available.first
  end
  
  def show
    @qrurl = Qr.find(params[:id]).generate
    respond_to do |format|
      format.html
      format.png  { render :qrcode => @qrurl }
      format.gif  { render :qrcode => @qrurl }
      format.jpeg { render :qrcode => @qrurl }
    end
  end
  
  def print_new_codes
    @codes = []
    24.times do
      @codes << Qr.create_brand_new
    end
    format_codes
    respond_to do |format|
      format.html
      #format.pdf  { render :pdf => "print_codes", :template => "qr_codes/print_codes.pdf.erb" }
    end
  end
  
  def print_existing_codes
    @codes = Qr.available.limit(24)
    format_codes
    respond_to do |format|
      format.html
      format.pdf  { render :pdf => "print_codes", :template => "qr_codes/print_codes.pdf.erb" }
    end
  end
  
  def import
    num_created, num_exists = Qr.import(params[:file]) 
    flash[:notice] = "Results of QR Code Import:  " + num_created.to_s + " created, " + num_exists.to_s + " already existed."
    redirect_to :action => :index and return
  end

  private

  def format_codes
    @qr_info = []
    @codes.each_with_index do |qr, i|
      data = RQRCode.render_qrcode(qr.generate, :png, {:unit => 3})
      filename = "/qr_codes/qr_code" + i.to_s + ".png"
      File.open("public" + filename, 'w+b') {|f| f.write(data) }
      @qr_info << ['MedSafeLabs ' + qr.qr_code.to_s, filename]
    end
  end

  def qr_code_params
    params[:qr_code].permit(:file)
  end
  
end
