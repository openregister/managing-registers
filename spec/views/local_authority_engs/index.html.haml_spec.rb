require 'rails_helper'

RSpec.describe "local_authority_engs/index", type: :view do
  before(:each) do
    assign(:local_authority_engs, [
      LocalAuthorityEng.create!(
        :code => "LDN",
        :name => "City of London",
        :official_name => "City of London Corporation",
        :local_authority_type => "CC",
        :start_date => "",
        :end_date => "",
      )
    ])
  end

  it "renders a list of local_authority_engs" do
    render
    assert_select "tr>td", :text => "City of London".to_s, :count => 2
    assert_select "tr>td", :text => "City of London Corporation".to_s, :count => 2
    assert_select "tr>td", :text => "LDN".to_s, :count => 2
  end
end
