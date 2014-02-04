class AddStrainToTest < ActiveRecord::Migration
  def change
    remove_column :tests, :strain
    add_reference :tests, :strain, index: true
  end
end
