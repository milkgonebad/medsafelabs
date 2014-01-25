class MakeSuperAdminActive < ActiveRecord::Migration
  def change
    super_admins = User.where(role:  0)
    super_admins.each {|i| i.update_attribute(:active, true)}
  end
end
