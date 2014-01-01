class AddAttachmentPlateToTests < ActiveRecord::Migration
  def self.up
    change_table :tests do |t|
      t.attachment :plate
    end
  end

  def self.down
    drop_attached_file :tests, :plate
  end
end
