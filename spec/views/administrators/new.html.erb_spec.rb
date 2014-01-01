require 'spec_helper'

describe "administrators/new" do
  before(:each) do
    assign(:administrator, stub_model(Administrator,
      :first_name => "MyString",
      :last_name => "MyString",
      :role => "MyString",
      :email => "MyString",
      :password => "MyString",
      :password_confirmation => "MyString",
      :active => false
    ).as_new_record)
  end

  it "renders new administrator form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", administrators_path, "post" do
      assert_select "input#administrator_first_name[name=?]", "administrator[first_name]"
      assert_select "input#administrator_last_name[name=?]", "administrator[last_name]"
      assert_select "input#administrator_role[name=?]", "administrator[role]"
      assert_select "input#administrator_email[name=?]", "administrator[email]"
      assert_select "input#administrator_password[name=?]", "administrator[password]"
      assert_select "input#administrator_password_confirmation[name=?]", "administrator[password_confirmation]"
      assert_select "input#administrator_active[name=?]", "administrator[active]"
    end
  end
end
