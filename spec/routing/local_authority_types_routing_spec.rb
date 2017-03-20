require "rails_helper"

RSpec.describe LocalAuthorityTypesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/local_authority_types").to route_to("local_authority_types#index")
    end

    it "routes to #edit" do
      expect(:get => "/local_authority_types/1/edit").to route_to("local_authority_types#edit", :id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/local_authority_types/1").to route_to("local_authority_types#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/local_authority_types/1").to route_to("local_authority_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/local_authority_types/1").to route_to("local_authority_types#destroy", :id => "1")
    end

  end
end
