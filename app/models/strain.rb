class Strain < ActiveRecord::Base
  has_many :tests, dependent: :restrict_with_error
  
  default_scope { order(:name) }
  
  validates :name, presence: true
  validates :name, uniqueness:  { case_sensitive: false }
  
  # def self.all
    # ['Blue Monday', 'True Faith', 'Regret', 'Bizarre Love Triangle']
  # end
  
end