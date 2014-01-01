class AddQuantityAndAmountToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :quantity, :integer
    add_column :orders, :total, :float
  end
end
