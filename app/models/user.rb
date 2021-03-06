class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  attr_accessor :terms
  
  has_many :orders
  has_many :tests, :through => :orders
  
  has_attached_file :credentials_image,  :default_url => "/images/:style/missing.png",
    styles: {
      thumb: '100x100>',
      square: '200x200>',
      medium: '300x300>'
    }
  
  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness:  { case_sensitive: false }
  validates :ccm_handle, uniqueness:  { case_sensitive: false }, length: { maximum: 100 }, unless: Proc.new { |a| a.admin? }
  validates :address1, :city, :state, presence: true, unless: Proc.new { |a| a.admin? }
  validates :control_number, numericality: { only_integer: true }, allow_nil: true, unless: Proc.new { |a| a.admin?}
  validates :postal_code, format: {with: /\A\d{5}\z/}, presence: true, unless: Proc.new { |a| a.admin?}
  validates :expires_on, presence: true, unless: Proc.new { |a| a.admin? }
  validate :expiration_date_cannot_be_in_the_past, on: :create
  
  validates :password, length: { in: 8..128 }, on: :create, if: Proc.new { |a| a.admin? }
  validates :password, length: { in: 8..128 }, on: :update, allow_blank: true
  validates :terms, acceptance: {accept: 'true'}, allow_nil: false, on: :update, unless: Proc.new { |a| a.admin? or a.registered?}
  
  validates :credentials_image, :attachment_presence => true, on: :create, unless: Proc.new { |a| a.admin? }
  validates_attachment_content_type :credentials_image, :content_type => %w(image/jpeg image/jpg image/png image/gif), on: :create, unless: Proc.new { |a| a.admin? }
  validates_attachment_file_name :credentials_image, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/], on: :create, unless: Proc.new { |a| a.admin? }
  validates_attachment_size :credentials_image, :in => 0..100.kilobytes, on: :create, unless: Proc.new { |a| a.admin? }
  
  scope :customers, -> { where(role: nil, active: true).order(:last_name, :first_name) } # note "->" is the same thing as "lamda" - very annoying
  scope :all_customers, -> { where(role: nil).order(:last_name, :first_name) }
  scope :administrators, -> { where("role in (1,2,3) and active = true").order(:last_name, :first_name) }
  scope :all_administrators, -> { where("role in (1,2,3)").order(:last_name, :first_name) }
  
  # administrators can do both lab_tech and customer_rep tasks
  ROLES = {:customer => nil, :super_administrator => 0, :administrator => 1, :lab_tech => 2, :customer_rep => 3}
  
  before_save do |u|
    u.email.downcase! if u.email
    u.ccm_handle.downcase if u.ccm_handle
  end
  
  # default the user to active
  after_create do |u|
    u.update_attribute(:active, true) if u.active.nil?
  end
  
  def self.assignable_admin_types
    {administrator: 1, lab_tech: 2, customer_rep: 3}
  end
  
  def role_name
    ROLES.each { |k,v| return k.to_s if v == role } 
  end
  
  def admin?
    !role.nil? 
  end
  
  def customer?
    role.nil?
  end
  
  def super_admin?
    role == ROLES[:super_administrator]
  end
  
  def administrator?
    role == ROLES[:administrator]
  end
  
  def lab_tech?
    role == ROLES[:lab_tech]
  end
  
  def customer_rep?
    role == ROLES[:customer_rep]
  end
  
  def can_run_tests?
    super_admin? or administrator? or lab_tech?
  end
  
  def can_manage_customers?
    super_admin? or administrator? or customer_rep?
  end
  
  def registered?
    invitation_accepted_at?
  end
  
  def destroy
    update_attribute(:active, false)
  end
  
  def active_for_authentication?
    super && active
  end
  
  def has_unused_tests?
    return false if tests.empty? 
    tests.not_received.empty? ? false : true
  end

  def inactive_message
    "Sorry, this account has been deactivated."
  end
  
  def password_required?
    if new_record?
      false
    else
      super
      #!persisted? || !password.nil? || !password_confirmation.nil?
    end
  end
  
  def delete
    update_attribute(:active, false)
  end
  
  def undelete
    update_attribute(:active, true)
  end

  def expiration_date_cannot_be_in_the_past
    if expires_on.present? && expires_on < Date.today
      errors.add(:expires_on, "cannot be in the past")
    end
  end

end
