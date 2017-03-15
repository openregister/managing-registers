require 'rails_helper'

RSpec.describe "countries/index", type: :view do
  before(:each) do
    assign(:countries, [
      Country.create!(
        :name => "United States",
        :citizen_name => "United States citizen",
        :official_name => "The United States of America",
        :start_date => "",
        :end_date => "",
        :code => "US"
      )
    ])
  end

  it "renders a list of countries" do
    render
    assert_select "tr>td", :text => "US".to_s, :count => 1
    assert_select "tr>td", :text => "United States".to_s, :count => 1
    assert_select "tr>td", :text => "The United States of America".to_s, :count => 1

  end
end
