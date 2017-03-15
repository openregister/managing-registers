require "rails_helper"

RSpec.describe TerritoriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/territories").to route_to("territories#index")
    end

    it "routes to #show" do
      expect(:get => "/territories/1").to route_to("territories#show", :id => "1")
    end

    it "routes to #success" do
      expect(:get => "/territories/1/success").to route_to("territories#success", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/territories/1/edit").to route_to("territories#edit", :id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/territories/1").to route_to("territories#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/territories/1").to route_to("territories#update", :id => "1")
    end

  end
end
