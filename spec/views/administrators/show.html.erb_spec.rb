require 'spec_helper'

describe "administrators/show" do
  before(:each) do
    @administrator = assign(:administrator, stub_model(Administrator,
      :first_name => "First Name",
      :last_name => "Last Name",
      :role => "Role",
      :email => "Email",
      :password => "Password",
      :password_confirmation => "Password Confirmation",
      :active => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/First Name/)
    rendered.should match(/Last Name/)
    rendered.should match(/Role/)
    rendered.should match(/Email/)
    rendered.should match(/Password/)
    rendered.should match(/Password Confirmation/)
    rendered.should match(/false/)
  end
end
