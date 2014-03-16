require 'csv'

class Qr < ActiveRecord::Base
  
  validates :qr_code, presence: true
  scope :available, -> { where used: nil }
  
  def self.import(file)
    num_created = 0
    num_exists = 0
    CSV.foreach(file.path, headers: true) do |row|
      exists = Qr.where(:qr_code => row[0])
      if exists.empty?
        Qr.create(:qr_code => row[0])
        num_created += 1
      else
        num_exists += 1
      end
    end
    [num_created, num_exists]
  end
  
  def self.create_brand_new
    create(:qr_code => self.maximum("qr_code") + 1)
  end
  
  def generate
    "https://" + ActionMailer::Base.default_url_options[:host] + "/qr/" + qr_code.to_s
  end
  
  # this should be run in the background using delayed job
  # this assumes you send in 24 new qr codes - the old images and pdf will be overwritten
  def self.generate_pdf_file(codes, email)
    qr_info = []
    s3 = AWS::S3.new
    bucket = s3.buckets[ENV['S3_BUCKET_NAME']] 
    # generate and save each code to amazon
    codes.each_with_index do |qr, i|
      img_name = 'qr_code' + i.to_s + '.png'
      data = RQRCode.render_qrcode(qr.generate, :png, {:unit => 3})
      img = bucket.objects[img_name].write(data)
      url = img.url_for(:read)
      logger.info "Created the following QR image:  " << img_name << " with url:  " << url.to_s
      puts "Created the following QR image:  " << img_name << " with url:  " << url.to_s
      qr_info << ['MedSafeLabs ' + qr.qr_code.to_s, url.to_s] 
    end
    # now using the codes, generate the pdf
    # create an instance of ActionView, so we can use the render method outside of a controller
    av = ActionView::Base.new()
    av.view_paths = ActionController::Base.view_paths

    # need these in case your view constructs any links or references any helper methods.
    av.class_eval do
      include Rails.application.routes.url_helpers
      include ApplicationHelper
    end
    
    pdf = WickedPdf.new.pdf_from_string(
      av.render(
        :pdf => "print_codes",
        :template => "qr_codes/print_codes.pdf.erb",
        :layout => nil,
        :locals => {:qr_info => qr_info}
      )
    )
    # save to amazon
    pdf_aws = bucket.objects["print_codes.pdf"].write(pdf)
    pdf_url = pdf_aws.url_for(:read)
    puts "AWS url:  " << pdf_url.inspect
    logger.info "AWS url:  " << pdf_url.inspect
    
    # email a notification to whom it may concern
    QrMailer.pdf_ready(pdf_url, email).deliver
    
    pdf_url
  end
  
end
