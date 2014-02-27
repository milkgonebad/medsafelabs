class AddPostalCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :postal_code, :string
    User.all.each {|i| i.update_attribute(:postal_code, '04101')} # default to Portland
  end
end
