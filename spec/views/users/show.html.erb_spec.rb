require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :first_name => "First Name",
      :last_name => "Last Name",
      :email => "Email",
      :address1 => "Address1",
      :address2 => "Address2",
      :city => "City",
      :state => "State",
      :country => "Country",
      :role => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/First Name/)
    rendered.should match(/Last Name/)
    rendered.should match(/Email/)
    rendered.should match(/Address1/)
    rendered.should match(/Address2/)
    rendered.should match(/City/)
    rendered.should match(/State/)
    rendered.should match(/Country/)
    rendered.should match(/1/)
  end
end
