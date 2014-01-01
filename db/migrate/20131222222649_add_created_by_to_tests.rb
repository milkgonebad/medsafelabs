class AddCreatedByToTests < ActiveRecord::Migration
  def change
    add_column :tests, :created_by, :integer
    add_column :tests, :received_by, :integer
    add_column :tests, :in_progress_by, :integer
    add_column :tests, :completed_by, :integer
  end
end
