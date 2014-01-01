class AddStatusFieldsToTest < ActiveRecord::Migration
  def change
    add_column :tests, :received_at, :datetime
    add_column :tests, :in_progress_at, :datetime
    add_column :tests, :completed_at, :datetime
  end
end
