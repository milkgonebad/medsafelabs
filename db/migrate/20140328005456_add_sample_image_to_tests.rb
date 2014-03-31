class AddSampleImageToTests < ActiveRecord::Migration
  def self.up
    change_table :tests do |t|
      t.attachment :sample
    end
  end

  def self.down
    drop_attached_file :tests, :sample
  end
end
