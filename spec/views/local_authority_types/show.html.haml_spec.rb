require 'rails_helper'

RSpec.describe "local_authority_types/show", type: :view do
  before(:each) do
    @local_authority_type = assign(:local_authority_type, LocalAuthorityType.create!(
      :local_authority_type => "Local Authority Type",
      :name => "Name",
      :start_date => "Start Date",
      :end_date => "End Date"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Local Authority Type/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Start Date/)
    expect(rendered).to match(/End Date/)
  end
end
