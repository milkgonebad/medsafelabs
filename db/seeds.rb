# create the ultra mega user

super_user = User.new(
  first_name: 'Super',
  last_name: 'Admin',
  email: 'super@medsafelabs.com',
  role: 0,
  password: 'P0rtland!',
  password_confirmation: 'P0rtland!',
  active: 1
)

super_user.save!
super_user.confirm!

first_qr = Qr.create(
  qr_code: 1
)
