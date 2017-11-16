require 'rails_helper'

RSpec.describe Team, type: :model do
  subject(:team) { build(:team) }

  it "has a valid factory" do
    expect(build(:team)).to be_valid
  end
end
