require 'rails_helper'

RSpec.describe "Territories", type: :request do
  describe "GET /territories" do
    it "works! (now write some real specs)" do
      get territories_path
      expect(response).to have_http_status(200)
    end
  end
end
