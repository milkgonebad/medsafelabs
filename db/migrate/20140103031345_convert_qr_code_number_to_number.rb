class ConvertQrCodeNumberToNumber < ActiveRecord::Migration
  def change
    add_column :qrs, :qr_code, :integer
    add_column :tests, :qr_id, :integer
  end
end
