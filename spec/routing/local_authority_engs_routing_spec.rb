require "rails_helper"

RSpec.describe LocalAuthorityEngsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/local_authority_engs").to route_to("local_authority_engs#index")
    end

    it "routes to #show" do
      expect(:get => "/local_authority_engs/1").to route_to("local_authority_engs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/local_authority_engs/1/edit").to route_to("local_authority_engs#edit", :id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/local_authority_engs/1").to route_to("local_authority_engs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/local_authority_engs/1").to route_to("local_authority_engs#update", :id => "1")
    end
  end
end
