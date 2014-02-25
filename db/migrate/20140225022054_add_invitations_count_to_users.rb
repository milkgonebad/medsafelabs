class AddInvitationsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invitations_count, :integer
  end
end
