require 'rails_helper'

RSpec.describe "local_authority_types/index", type: :view do
  before(:each) do
    assign(:local_authority_types, [
      LocalAuthorityType.create!(
        :local_authority_type => "Local Authority Type",
        :name => "Name",
        :start_date => "Start Date",
        :end_date => "End Date"
      ),
      LocalAuthorityType.create!(
        :local_authority_type => "Local Authority Type",
        :name => "Name",
        :start_date => "Start Date",
        :end_date => "End Date"
      )
    ])
  end

  it "renders a list of local_authority_types" do
    render
    assert_select "tr>td", :text => "Local Authority Type".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Start Date".to_s, :count => 2
    assert_select "tr>td", :text => "End Date".to_s, :count => 2
  end
end
