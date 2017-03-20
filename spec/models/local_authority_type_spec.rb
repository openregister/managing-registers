require 'rails_helper'

RSpec.describe LocalAuthorityType, type: :model do
  let(:country) { FactoryGirl.build(:local_authority_type) }
  subject { local_authority_type }

  it "should be valid and save" do
    expect(country).to be_valid
    expect(country.save).to be_truthy
  end
end
