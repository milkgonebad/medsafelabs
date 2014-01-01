class Order < ActiveRecord::Base
  belongs_to :user # customer
  has_many :tests
  belongs_to :creator, class_name: "User", foreign_key:  "created_by"
  
  after_create :create_tests
  
  validates :payment_type, :total, :quantity, presence: true
  validates :total, numericality: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  
  PAYMENT_TYPES = ['Credit Card', 'Cash', 'PayPal', 'Other']

  def set_defaults
    self.quantity = 1
    self.total = 50
  end

  protected
  
  def create_tests
    self.quantity.times { self.tests.create(:user => self.user, :creator => self.creator) }
    logger.debug "I would create a test here this many times:  " << quantity.to_s
  end
  
end
