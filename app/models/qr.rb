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
  
end
