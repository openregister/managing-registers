require 'rails_helper'
require 'spec_helper'
require 'yaml'

RSpec.describe ValidationHelper do
  field_definitions = YAML.load_file('./spec/support/field_definitions.yaml')
  data_validator = ValidationHelper::DataValidator.new

  describe "get_form_errors" do
    it "returns an error if date is valid" do
      params = {"start-date"=>"foo"}
      expect(data_validator.get_form_errors(params,field_definitions).eql?({"start-date"=>{:success=>false, :message=>"foo is not a valid date format"}}))
    end

    it "returns no errors if date is valid" do
      params = {"start-date"=>"2015-05"}
      expect(data_validator.get_form_errors(params, field_definitions)).to be_empty
    end

    it "returns an error if key is not populated" do
      params = {:country=>'', :register=>"country"}
      expect(data_validator.get_form_errors(params, field_definitions)).eql?({"country"=>{:success=>false, :message=>"Field country is required"}})
    end
  end

end
