class AddActiveToUser < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end
  
  def change
    add_column :users, :active, :boolean
    User.reset_column_information
    reversible do |dir|
      dir.up { User.update_all active: true }
    end
  end
end
