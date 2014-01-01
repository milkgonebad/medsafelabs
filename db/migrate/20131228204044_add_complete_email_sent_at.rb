class AddCompleteEmailSentAt < ActiveRecord::Migration
  def change
    add_column :tests, :completed_email_sent_at, :datetime
  end
end
