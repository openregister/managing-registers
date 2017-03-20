require 'rails_helper'

RSpec.describe LocalAuthorityEng, type: :model do
  let(:local_authority_eng) { FactoryGirl.build(:local_authority_eng) }
  subject { local_authority_eng }

  it "should be valid and save" do
    expect(local_authority_eng).to be_valid
    expect(local_authority_eng.save).to be_truthy
  end
end
