class Test < ActiveRecord::Base
  belongs_to :order
  belongs_to :user # customer user - not so normalized
  belongs_to :creator, class_name: "User", foreign_key:  "created_by"
  belongs_to :receiver, class_name: "User", foreign_key:  "received_by"
  belongs_to :in_progresser, class_name: "User", foreign_key:  "in_progress_by"
  belongs_to :completer, class_name: "User", foreign_key:  "completed_by"
  belongs_to :qr
  belongs_to :strain
  
  has_attached_file :plate,  :default_url => "/images/:style/missing.png",
    styles: {
      thumb: '100x100>',
      square: '200x200>',
      medium: '300x300>'
    }
  has_attached_file :sample,  :default_url => "/images/:style/missing.png",
    styles: {
      thumb: '100x100>',
      square: '200x200>',
      medium: '300x300>'
    }
  
  validates :order, :status, :user, :creator, presence: true # tests cannot exist without an order
  validates :qr_id, presence: true, if: :received?
  validates :qr_id, absence: true, if: :not_received?
  validates :sample_type, presence: true, if: :received?
  validates :cbd, :cbn, :thc, :thcv, :cbg, :cbc, :thca, numericality: { less_than_or_equal_to: 50.00 }, allow_blank: true
  validates :cbd, :cbn, :thc, :thcv, :cbg, :cbc, :thca, :strain, :sample_type, presence: true, if: :complete? 
  
  #FIXME we should be able to roll all of these paper clip validations together but they don't seem to be working
  validates :plate, :attachment_presence => true, if: :complete?
  validates_attachment_content_type :plate, :content_type => %w(image/jpeg image/jpg image/png image/gif), if: :complete?
  validates_attachment_file_name :plate, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/], if: :complete?
  validates_attachment_size :plate, :in => 0..100.kilobytes, if: :complete?
  
  #FIXME this could be DRYed up
  validates :sample, :attachment_presence => true, if: :complete?
  validates_attachment_content_type :sample, :content_type => %w(image/jpeg image/jpg image/png image/gif), if: :complete?
  validates_attachment_file_name :sample, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/], if: :complete?
  validates_attachment_size :sample, :in => 0..100.kilobytes, if: :complete?

  STATUSES = {not_received: 'NOT_RECEIVED', received: 'RECEIVED', in_progress: 'IN_PROGRESS', complete: 'COMPLETE'}
  SAMPLE_TYPES = ['Flower', 'Concentrate', 'Oil', 'Edible']
  
  scope :no_qr_code, -> { where qr_id: nil }
  scope :not_received, -> { where status: STATUSES[:not_received] }
  scope :received, -> { where status: STATUSES[:received] }
  scope :in_progress, -> { where status: STATUSES[:in_progress] }
  scope :complete, -> { where status: STATUSES[:complete] }
  scope :used, -> { where "status != ?", STATUSES[:not_received] }
  
  attr_accessor :updated_by, :new_strain
  
  after_initialize do |t|
    t.status = STATUSES[:not_received] if t.status.nil?
  end
  
  before_validation :add_new_strain, if: "new_strain.present?" # I don't know how I feel about using string eval
  after_save :update_status_timestamps
  
  after_save do |t| 
    t.send_test_result_email if t.complete?
    t.mark_qr_code if t.received?
  end
  
  #FIXME:  These could be metaprogrammed into something smarter but rails 4.1 has that nice enum feature...
  def in_progress?
    status == STATUSES[:in_progress]
  end
  
  def complete?
    status == STATUSES[:complete]
  end
  
  def not_received?
    status == STATUSES[:not_received]
  end
  
  def received?
    status == STATUSES[:received]
  end
  
  def next_status
    case status
      when STATUSES[:not_received]
        STATUSES[:received]
      when STATUSES[:received]
        STATUSES[:in_progress]
      when STATUSES[:in_progress]
        STATUSES[:complete]
      else
        status # this shouldn't happen
    end
  end
  
  def editable?
    in_progress? or received?
  end
  
  # FIXME:  This should be a helper
  def result_url
    '/results/' + id.to_s
  end
  
  # FIXME:  This should go a in a helper too
  def strain_name
    strain.present? ? strain.name : ""
  end
  
  protected
  
  #FIXME:  Yep, ugly!
  def update_status_timestamps
    if valid?
      case status
        when STATUSES[:received]
          if received_at.nil?
            update_attribute(:received_at, Time.now) 
            update_attribute(:received_by, updated_by.id) 
          end
        when STATUSES[:in_progress]
          if in_progress_at.nil?
            update_attribute(:in_progress_at, Time.now) 
            update_attribute(:in_progress_by, updated_by.id) 
          end
        when STATUSES[:complete]
          if completed_at.nil?
            update_attribute(:completed_at, Time.now) 
            update_attribute(:completed_by, updated_by.id) 
          end
      end
    end
  end
  
  def add_new_strain
    if new_strain.present? 
      if Strain.where(name: new_strain).empty?
        self.strain = Strain.create!(name: new_strain)
      else
        errors.add(:new_strain, "already exists.")
        false
      end
    end
  end
  
  def send_test_result_email
    # first ensure we haven't already sent the email - spam is bad but it really shouldn't happen
    if completed_email_sent_at.nil?
      TestMailer.results_available(self).deliver
      update_attribute(:completed_email_sent_at, Time.now)
    end
  end 
  
  def mark_qr_code
    qr.used = true
    qr.save!
  end
  
end
