require 'rails_helper'
require 'spec_helper'
require 'yaml'

RSpec.describe ValidationHelper do
  field_definitions = YAML.load_file('./spec/support/field_definitions.yaml')
  records = YAML.load_file('./spec/support/records.yml')
  data_validator = ValidationHelper::DataValidator.new

  describe 'get_form_errors' do
    before do
      data = File.open('./spec/support/country_gm.tsv', &:read)
      stub_request(:get, 'https://country.register.gov.uk/record/GM.tsv')
        .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' })
        .to_return(status: 200, body: data, headers: {})

      stub_request(:get, 'https://country.register.gov.uk/record/ZZ.tsv')
        .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' })
        .to_return(status: 404)
    end

    it 'returns an error if date is invalid' do
      %w[X123 123X foo 20145 201].each do |d|
        params = { 'start-date' => d, 'country' => 'zz' }
        expect(data_validator.get_form_errors(params, field_definitions, 'country', nil).messages).to eql(start_date: ['Enter a valid date'])
      end
    end

    it 'returns no errors if date is valid' do
      ['2014', '2014-05', '2014-05-01', '2017-10-19T08:10:49', '2017-10-19T08:10:49Z'].each do |d|
        params = { 'start-date' => d, 'country' => 'xx' }
        expect(data_validator.get_form_errors(params, field_definitions, 'country', nil).details).to be_empty
      end
    end

    it 'returns an error if key is not populated' do
      params = { country: '', register: 'country' }
      expect(data_validator.get_form_errors(params, field_definitions, 'country', nil).messages).to eql(country: ['Field Country is required'])
    end

    it 'returns an error if key already exists when performing a create' do
      params = { 'country' => 'SU', 'is_create': 'true' }
      expect(data_validator.get_form_errors(params, field_definitions, 'country', records).messages).to eql(country: ['This code is already in use for another record, please use another code'])
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
