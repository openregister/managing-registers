require 'rails_helper'

RSpec.describe TeamMember, type: :model do

  subject(:team_member) { build(:team_member) }

  it "has a valid factory" do
    expect(build(:team_member)).to be_valid
  end
end
