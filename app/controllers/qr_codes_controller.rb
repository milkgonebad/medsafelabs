class QrCodesController < ApplicationController
  before_filter :authenticate_user!, :ensure_admin
  before_filter :ensure_can_manage_customers

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
  
  #FIXME:  Please dry these up
  
  def print_new_codes
    @codes = []
    24.times do
      @codes << Qr.create_brand_new
    end
    if params[:format] == 'pdf'
      codes = []
      @codes.each {|c| codes << c.id}
      Delayed::Job.enqueue PdfJob.new(codes, current_user.email)
      flash[:notice] = "Check your email for the qr codes pdf file.  This was mailed to:  " << current_user.email
      redirect_to :action => :index and return
    else
      respond_to do |format|
        format.html { render "qr_codes/print_codes"}
        #format.pdf  { render :pdf => "print_codes", :template => "qr_codes/print_codes.pdf.erb" }
      end
    end
  end
  
  def print_existing_codes
    @codes = Qr.available.limit(24)
    if params[:format] == 'pdf'
      codes = []
      @codes.each {|c| codes << c.id}
      Delayed::Job.enqueue PdfJob.new(codes, current_user.email)
      flash[:notice] = "Check your email for the qr codes pdf file.  This was mailed to:  " << current_user.email
      redirect_to :action => :index and return
    else
      respond_to do |format|
        format.html { render "qr_codes/print_codes"}
        # format.pdf  { render :pdf => "print_codes", :template => "qr_codes/print_codes.pdf.erb" }
      end
    end
  end
  
  def import
    num_created, num_exists = Qr.import(params[:file]) 
    flash[:notice] = "Results of QR Code Import:  " + num_created.to_s + " created, " + num_exists.to_s + " already existed."
    redirect_to :action => :index and return
  end
  
  def image
    qr = Qr.find(params[:id])
    data = RQRCode.render_qrcode(qr.generate, :png, {:unit => 3})
    send_data data, :type => 'image/png', :disposition => 'inline'
  end

  private

  def format_codes
    @qr_info = []
    s3 = AWS::S3.new
    bucket = s3.buckets[ENV['S3_BUCKET_NAME']]
    @codes.each_with_index do |qr, i|
      img_name = 'qr_code' + i.to_s + '.png'
      data = RQRCode.render_qrcode(qr.generate, :png, {:unit => 3})
      img = bucket.objects[img_name].write(data)
      url = img.url_for(:read)
      #logger.info "Created the following QR image:  " << img_name << " with url:  " << url.to_s
      @qr_info << ['MedSafeLabs ' + qr.qr_code.to_s, url.to_s] 
    end
  end

  def qr_code_params
    params[:qr_code].permit(:file)
  end
  
end
