class CreateQrs < ActiveRecord::Migration
  def change
    create_table :qrs do |t|
      t.string :qr_code_number
      t.boolean :used

      t.timestamps
    end
  end
end
