require 'rails_helper'

RSpec.describe Register, type: :model do

  subject(:register) { build(:register) }

  it "has a valid factory" do
    expect(build(:register)).to be_valid
  end
end
