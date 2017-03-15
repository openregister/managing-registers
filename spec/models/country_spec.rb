require 'rails_helper'

RSpec.describe Country, type: :model do
  let(:country) { FactoryGirl.build(:country) }
  subject { country }

  it "should be valid and save" do
    expect(country).to be_valid
    expect(country.save).to be_truthy
  end
end
