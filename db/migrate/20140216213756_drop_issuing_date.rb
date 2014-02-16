class DropIssuingDate < ActiveRecord::Migration
  def change
    remove_column :users, :issued_on
  end
end
