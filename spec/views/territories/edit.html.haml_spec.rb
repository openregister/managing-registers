require 'rails_helper'

RSpec.describe "territories/edit", type: :view do
  before(:each) do
    @territory = assign(:territory, Territory.create!(
      :name => "MyString",
      :official_name => "MyString",
      :start_date => "MyString",
      :end_date => "MyString",
      :code => "MyString",
    ))
  end

  it "renders the edit territory form" do
    render

    assert_select "form[action=?][method=?]", territory_path(@territory), "post" do

      assert_select "input#territory_name[name=?]", "territory[name]"

      assert_select "input#territory_official_name[name=?]", "territory[official_name]"

      assert_select "input#territory_start_date[name=?]", "territory[start_date]"

      assert_select "input#territory_end_date[name=?]", "territory[end_date]"

      assert_select "input#territory_code[name=?]", "territory[code]"
    end
  end
end
