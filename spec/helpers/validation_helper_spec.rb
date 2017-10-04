require 'rails_helper'
require 'spec_helper'
require 'yaml'

RSpec.describe ValidationHelper do
  field_definitions = YAML.load_file('./spec/support/field_definitions.yaml')
  data_validator = ValidationHelper::DataValidator.new

  describe "get_form_errors" do
    it "returns an error if date is invalid" do
      params = {"start-date"=>"foo", "country" => "zz"}
      expect(data_validator.get_form_errors(params,field_definitions, 'country',  nil).messages).to eql({:start_date=>["foo is not a valid date"]})
    end

    it "returns no errors if date is valid" do
      params = {"start-date"=>"2015-05", "country"=>"xx" }
      expect(data_validator.get_form_errors(params, field_definitions, 'country', nil).details).to be_empty
    end

    it "returns an error if key is not populated" do
      params = {:country=>'', :register=>"country"}
      expect(data_validator.get_form_errors(params, field_definitions, 'country',  nil).messages).to eql({:country => ["Field Country is required"]})
    end
  end

end
