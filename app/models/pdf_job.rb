class PdfJob < Struct.new(:codes, :email)
  
  def perform
    pdf_url = Qr.generate_pdf_file(codes, email)
    QrMailer.pdf_ready(pdf_url, email).deliver
  end

  def error(job, exception)
    ExceptionNotifier.notify_exception(exception, :data => {:worker => job.inspect})
  end

end