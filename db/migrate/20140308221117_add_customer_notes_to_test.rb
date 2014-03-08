class AddCustomerNotesToTest < ActiveRecord::Migration
  def change
    add_column :tests, :customer_notes, :text
  end
end
