require 'rails_helper'

RSpec.describe "LocalAuthorityTypes", type: :request do
  describe "GET /local_authority_types" do
    it "works! (now write some real specs)" do
      get local_authority_types_path
      expect(response).to have_http_status(200)
    end
  end
end
