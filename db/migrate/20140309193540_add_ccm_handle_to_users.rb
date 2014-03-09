class AddCcmHandleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ccm_handle, :string
  end
end
