class DropQrCodeNumberFromQrs < ActiveRecord::Migration
  def change
    remove_column :qrs, :qr_code_number
  end
end
