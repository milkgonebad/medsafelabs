class Test < ActiveRecord::Base
  belongs_to :order
  belongs_to :user # customer user - not so normalized
  belongs_to :creator, class_name: "User", foreign_key:  "created_by"
  belongs_to :receiver, class_name: "User", foreign_key:  "received_by"
  belongs_to :in_progresser, class_name: "User", foreign_key:  "in_progress_by"
  belongs_to :completer, class_name: "User", foreign_key:  "completed_by"
  
  has_attached_file :plate,  :default_url => "/images/:style/missing.png",
    styles: {
      thumb: '100x100>',
      square: '200x200>',
      medium: '300x300>'
    }
  
  validates :order, :status, :user, :creator, presence: true # tests cannot exist without an order
  validates :qr_code_number, presence: true, if: :received?
  validates :cbd, :cbn, :thc, :thcv, :cbg, :cbc, :thca, numericality: { less_than_or_equal_to: 50.00 }, allow_blank: true
  validates :cbd, :cbn, :thc, :thcv, :cbg, :cbc, :thca, :strain, :sample_type, presence: true, if: :complete? 
  
  #FIXME:  the content type and size validations are not working 
  # see https://github.com/thoughtbot/paperclip/issues/1292
  validates :plate, :attachment_presence => true, if: :complete?
  # validates_attachment :plate, :presence => true, :content_type => { :content_type => ["image/jpg", "image/gif", "image/png"] },
    # :size => { :in => 0..10.kilobytes }, if: :complete?

  STATUSES = {not_received: 'NOT_RECEIVED', received: 'RECEIVED', in_progress: 'IN_PROGRESS', complete: 'COMPLETE'}
  SAMPLE_TYPES = ['Flower', 'Concentrate', 'Oil', 'Edible']
  
  scope :no_qr_code, -> { where qr_code_number: nil }
  scope :not_received, -> { where status: STATUSES[:not_received] }
  scope :received, -> { where status: STATUSES[:received] }
  scope :in_progress, -> { where status: STATUSES[:in_progress] }
  scope :complete, -> { where status: STATUSES[:complete] }
  
  attr_accessor :updated_by
  
  after_initialize do |t|
    t.status = STATUSES[:not_received] if t.status.nil?
  end
  
  after_save :update_status_timestamps
  
  after_save  do |t| 
    t.send_test_result_email if t.complete?
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
  
  def result_url
    '/results/' + id.to_s
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
  
  def send_test_result_email
    # first ensure we haven't already sent the email - spam is bad but it really shouldn't happen
    if completed_email_sent_at.nil?
      TestMailer.results_available(self).deliver
      update_attribute(:completed_email_sent_at, Time.now)
    end
  end 
  
end
