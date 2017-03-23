require "rails_helper"

RSpec.describe CountriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/countries").to route_to("countries#index")
    end

    it "routes to #show" do
      expect(:get => "/countries/1").to route_to("countries#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/countries/1/edit").to route_to("countries#edit", :id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/countries/1").to route_to("countries#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/countries/1").to route_to("countries#update", :id => "1")
    end

  end
end
