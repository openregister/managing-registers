require 'rails_helper'

RSpec.describe "countries/show", type: :view do
  before(:each) do
    @country = assign(:country, Country.create!(
      :name => "Name",
      :citizen_name => "Citizen Name",
      :official_name => "Official Name",
      :start_date => "Start Date",
      :end_date => "End Date",
      :code => "Code"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Citizen Name/)
    expect(rendered).to match(/Official Name/)
    expect(rendered).to match(/Start Date/)
    expect(rendered).to match(/End Date/)
    expect(rendered).to match(/Code/)
  end
end
