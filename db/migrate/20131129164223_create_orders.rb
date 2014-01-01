class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.text :memo
      t.string :payment_type
      t.timestamps
      t.references :user # customer id
      t.integer :admin_id # admin user id - can be null - whomever created the order
    end
  end
end

