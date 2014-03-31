class AddCredentialsImageToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :credentials_image
    end
  end

  def self.down
    drop_attached_file :users, :credentials_image
  end
end
