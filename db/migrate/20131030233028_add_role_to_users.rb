class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer # nil is normal user, 1 is ultra admin, 2 is regular admin - we can add more later if needed
  end
end
