class AddRegistrationNumberAndControlNumberAndIssuedDateAndExpirationDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :registration_number, :string
    add_column :users, :control_number, :integer
    add_column :users, :issued_on, :date
    add_column :users, :expires_on, :date
  end
end
