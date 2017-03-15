require 'rails_helper'

RSpec.describe Territory, type: :model do
  let(:territory) { FactoryGirl.build(:territory) }
  subject { territory }

  it "should be valid and save" do
    expect(territory).to be_valid
    expect(territory.save).to be_truthy
  end
end
