require 'spec_helper'

describe "qr_codes/index" do
  before(:each) do
    assign(:qr_codes, [
      stub_model(QrCode),
      stub_model(QrCode)
    ])
  end

  it "renders a list of qr_codes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
