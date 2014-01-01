require 'spec_helper'

describe "qr_codes/new" do
  before(:each) do
    assign(:qr_code, stub_model(QrCode).as_new_record)
  end

  it "renders new qr_code form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", qr_codes_path, "post" do
    end
  end
end
