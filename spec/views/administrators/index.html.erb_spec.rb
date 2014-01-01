require 'spec_helper'

describe "administrators/index" do
  before(:each) do
    assign(:administrators, [
      stub_model(Administrator,
        :first_name => "First Name",
        :last_name => "Last Name",
        :role => "Role",
        :email => "Email",
        :password => "Password",
        :password_confirmation => "Password Confirmation",
        :active => false
      ),
      stub_model(Administrator,
        :first_name => "First Name",
        :last_name => "Last Name",
        :role => "Role",
        :email => "Email",
        :password => "Password",
        :password_confirmation => "Password Confirmation",
        :active => false
      )
    ])
  end

  it "renders a list of administrators" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Role".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Password".to_s, :count => 2
    assert_select "tr>td", :text => "Password Confirmation".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
