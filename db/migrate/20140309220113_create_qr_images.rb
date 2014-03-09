class CreateQrImages < ActiveRecord::Migration
  def change
    create_table :qr_images do |t|
      t.integer :count #0-23
      t.integer :qr_id #qr we're using
      t.string :name # text
      t.binary :data # blob of image data
      t.timestamps
    end
  end
end
