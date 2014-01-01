require 'spec_helper'

describe "users/new" do
  before(:each) do
    assign(:user, stub_model(User,
      :first_name => "MyString",
      :last_name => "MyString",
      :email => "MyString",
      :address1 => "MyString",
      :address2 => "MyString",
      :city => "MyString",
      :state => "MyString",
      :country => "MyString",
      :role => 1
    ).as_new_record)
  end

  it "renders new user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", users_path, "post" do
      assert_select "input#user_first_name[name=?]", "user[first_name]"
      assert_select "input#user_last_name[name=?]", "user[last_name]"
      assert_select "input#user_email[name=?]", "user[email]"
      assert_select "input#user_address1[name=?]", "user[address1]"
      assert_select "input#user_address2[name=?]", "user[address2]"
      assert_select "input#user_city[name=?]", "user[city]"
      assert_select "input#user_state[name=?]", "user[state]"
      assert_select "input#user_country[name=?]", "user[country]"
      assert_select "input#user_role[name=?]", "user[role]"
    end
  end
end
