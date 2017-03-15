require 'rails_helper'

RSpec.describe "countries/edit", type: :view do
  before(:each) do
    @country = assign(:country, Country.create!(
      :name => "MyString",
      :citizen_name => "MyString",
      :official_name => "MyString",
      :start_date => "MyString",
      :end_date => "MyString",
      :code => "MyString",
    ))
  end

  it "renders the edit country form" do
    render

    assert_select "form[action=?][method=?]", country_path(@country), "post" do

      assert_select "input#country_name,[name=?]", "country[name,]"

      assert_select "input#country_citizen_name,[name=?]", "country[citizen_name,]"

      assert_select "input#country_official_name,[name=?]", "country[official_name,]"

      assert_select "input#country_start_date,[name=?]", "country[start_date,]"

      assert_select "input#country_end_date,[name=?]", "country[end_date,]"

      assert_select "input#country_code[name=?]", "country[code]"
    end
  end
end
