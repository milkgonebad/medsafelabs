require 'spec_helper'

describe "qr_codes/edit" do
  before(:each) do
    @qr_code = assign(:qr_code, stub_model(QrCode))
  end

  it "renders the edit qr_code form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", qr_code_path(@qr_code), "post" do
    end
  end
end
