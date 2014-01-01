class RemoveAdminIdFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :admin_id
  end
end
