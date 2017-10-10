require 'rails_helper'
require 'spec_helper'
require 'yaml'

RSpec.describe ValidationHelper do
  field_definitions = YAML.load_file('./spec/support/field_definitions.yaml')
  data_validator = ValidationHelper::DataValidator.new

  describe 'get_form_errors' do
    before do
      data = File.open('./spec/support/country_gm.tsv') { |f| f.read }
      stub_request(:get, 'https://country.beta.openregister.org/record/GM.tsv')
        .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.beta.openregister.org' })
        .to_return(status: 200, body: data, headers: {})

      stub_request(:get, 'https://country.beta.openregister.org/record/ZZ.tsv')
        .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.beta.openregister.org' })
        .to_return(status: 404)
    end

    it 'returns an error if date is invalid' do
      params = { 'start-date' => 'foo', 'country' => 'zz' }
      expect(data_validator.get_form_errors(params, field_definitions, 'country', nil).messages).to eql(start_date: ['Enter a valid date'])
    end

    it 'returns no errors if date is valid' do
      params = { 'start-date' => '2015-05', 'country' => 'xx' }
      expect(data_validator.get_form_errors(params, field_definitions, 'country', nil).details).to be_empty
    end

    it 'returns an error if key is not populated' do
      params = { country: '', register: 'country' }
      expect(data_validator.get_form_errors(params, field_definitions, 'country', nil).messages).to eql(country: ['Field Country is required'])
    end

    it 'returns no errors if curie is valid' do
      params = { 'curie-field' => 'country:GM', 'country' => 'aa' }
      expect(data_validator.get_form_errors(params, field_definitions, 'country', nil).details).to be_empty
    end

    it 'returns an error if key does not exist' do
      params = { 'curie-field' => 'country:ZZ', 'country' => 'aa' }
      expect(data_validator.get_form_errors(params, field_definitions, 'country', nil).details).to eql(curie_field: [error: 'Must be valid data from a register that is ready to use'])
    end

    it 'returns an error if key is not in a valid format' do
      params = { 'curie-field' => 'country::', 'country' => 'aa' }
      expect(data_validator.get_form_errors(params, field_definitions, 'country', nil).details).to eql(curie_field: [error: 'Must be valid data from a register that is ready to use'])
    end

    it 'returns no errors if curie is empty' do
      params = { 'curie-field' => '', 'country' => 'aa' }
      expect(data_validator.get_form_errors(params, field_definitions, 'country', nil).details).to be_empty
    end
  end
end
