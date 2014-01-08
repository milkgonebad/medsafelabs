require 'csv'

class Qr < ActiveRecord::Base
  scope :available, -> { where used: nil }
  
  def self.import(file)
    num_created = 0
    num_exists = 0
    CSV.foreach(file.path, headers: true) do |row|
      exists = Qr.where(:qr_code_number => row[0])
      if exists.empty?
        Qr.create(:qr_code_number => row[0])
        num_created += 1
      else
        num_exists += 1
      end
    end
    [num_created, num_exists]
  end
  
  def self.create_brand_new
    # get max qr code number
    
    # convert the field to number
    
    # 
    
  end
  
  def generate
    "https://" + ActionMailer::Base.default_url_options[:host] + "/qr/" + qr_code_number.to_s
  end
  
end
