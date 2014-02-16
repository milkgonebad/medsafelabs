class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  attr_accessor :terms
  
  has_many :orders
  has_many :tests, :through => :orders
  
  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness:  { case_sensitive: false }
  validates :address1, :city, :state, :country, presence: true, unless: Proc.new { |a| a.admin? }
  validates :control_number, numericality: { only_integer: true }, allow_nil: true, unless: Proc.new { |a| a.admin?}
  
  validates :password, length: { in: 8..128 }, on: :create, if: Proc.new { |a| a.admin? }
  validates :password, length: { in: 8..128 }, on: :update, allow_blank: true
  validates :terms, acceptance: {accept: 'true'}, allow_nil: false, on: :update, unless: Proc.new { |a| a.admin? or a.registered?}
  
  scope :customers, -> { where(role: nil, active: true).order(:last_name, :first_name) } # note "->" is the same thing as "lamda" - very annoying
  scope :all_customers, -> { where(role: nil).order(:last_name, :first_name) }
  scope :administrators, -> { where(role: 1, active: true).order(:last_name, :first_name) }
  scope :all_administrators, -> { where('role is not null').order(:last_name, :first_name) }
  
  ROLES = {:customer => nil, :super_administrator => 0, :administrator => 1}
  
  before_save do |u|
    u.email.downcase! if u.email
  end
  
  # default the user to active
  after_create do |u|
    u.update_attribute(:active, true) if u.active.nil?
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
  
  def registered?
    invitation_accepted_at?
  end
  
  def destroy
    update_attribute(:active, false)
  end
  
  def active_for_authentication?
    super && active
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
    update_attribute(:active, false)
  end

end
