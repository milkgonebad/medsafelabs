class QrMailer < ActionMailer::Base
  default from: "no-reply@medsafelabs.com"
  layout 'mailer'
  
  def pdf_ready(pdf_url, to)
    @pdf_url = pdf_url
    mail(to: to, subject: "PDF of QR codes is available (" + Rails.env.to_s + ")") 
  end
  
end
