require 'rails_helper'

RSpec.describe "local_authority_engs/show", type: :view do
  before(:each) do
    @local_authority_eng = assign(:local_authority_eng, LocalAuthorityEng.create!(
      :name => "Name",
      :start_date => "Start Date",
      :end_date => "End Date",
      :local_authority_type => "Local Authority Type",
      :code => "Code"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Start Date/)
    expect(rendered).to match(/End Date/)
    expect(rendered).to match(/Local Authority Type/)
    expect(rendered).to match(/Code/)
  end
end
