class AddPublishToUsers < ActiveRecord::Migration
  def change
    add_column :users, :publish, :boolean
  end
end
