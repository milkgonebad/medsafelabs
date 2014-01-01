class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.text :notes
      t.string :status
      t.string :strain
      t.string :qr_code_number
      t.string :sample_type
      t.integer :cbn
      t.integer :thc
      t.integer :thcv
      t.integer :cbg
      t.integer :thca
      t.timestamps
      t.references :order
      t.references :user # tester
    end
  end
end

# fks
# tester id
# order id