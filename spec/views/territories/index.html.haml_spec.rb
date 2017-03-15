require 'rails_helper'

RSpec.describe "territories/index", type: :view do
  before(:each) do
    assign(:territories, [
      Territory.create!(
        :name => "Isle of Man",
        :official_name => "Isle of Man",
        :start_date => "",
        :end_date => "",
        :code => "IM"
      )
    ])
  end

  it "renders a list of territories" do
    render
    assert_select "tr>td", :text => "IM".to_s, :count => 1
    assert_select "tr>td", :text => "Isle of Man".to_s, :count => 1
    assert_select "tr>td", :text => "Isle of Man".to_s, :count => 1
  end
end
