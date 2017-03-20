require 'rails_helper'

RSpec.describe "LocalAuthorityEngs", type: :request do
  describe "GET /local_authority_engs" do
    it "works! (now write some real specs)" do
      get local_authority_engs_path
      expect(response).to have_http_status(200)
    end
  end
end
