class AddColumnsToTest < ActiveRecord::Migration
  def change
    add_column :tests, :cbd, :float
    add_column :tests, :cbc, :float
    change_column :tests, :cbn, :float
    change_column :tests, :thc, :float
    change_column :tests, :thcv, :float
    change_column :tests, :cbg, :float
    change_column :tests, :thca, :float
  end
end
