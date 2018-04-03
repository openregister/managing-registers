require 'rails_helper'
require 'spec_helper'
require 'yaml'

RSpec.describe ValidationHelper do
  before do
    @registers_client = RegistersClient::RegisterClientManager.new
    stub('https://government-organisation.register.gov.uk/download-rsf/0', './spec/support/government_organisation.rsf')
  end

  field_definitions = YAML.load_file('./spec/support/field_definitions_government_domain.yml')
  records = YAML.load_file('./spec/support/records_government_domain.yml')
  data_validator = ValidationHelper::DataValidator.new

  describe 'get_form_errors' do
    it 'returns an error if date is invalid' do
      %w[X123 123X foo 20145 201].each do |d|
        params = { 'start-date' => d, 'government-domain' => 'zz' }
        expect(data_validator.get_form_errors(params, field_definitions, 'government-domain', nil, @registers_client).messages).to eql(start_date: ['Enter a valid date'])
      end
    end

    it 'returns no errors if date is valid' do
      ['2014', '2014-05', '2014-05-01', '2017-10-19T08:10:49', '2017-10-19T08:10:49Z'].each do |d|
        params = { 'start-date' => d, 'government-domain' => 'xx' }
        expect(data_validator.get_form_errors(params, field_definitions, 'government-domain', nil, @registers_client).details).to be_empty
      end
    end

    it 'returns an error if key is not populated' do
      params = { 'government-domain': '', register: 'government-domain' }
      expect(data_validator.get_form_errors(params, field_definitions, 'government-domain', nil, @registers_client).messages).to eql(government_domain: ['Field Government domain is required'])
    end

    it 'returns an error if key already exists when performing a create' do
      params = { 'government-domain' => '4793', 'is_create': 'true' }
      expect(data_validator.get_form_errors(params, field_definitions, 'government-domain', records, @registers_client).messages).to eql(government_domain: ['This code is already in use for another record, please use another code'])
    end

    it 'returns no errors if curie is valid' do
      params = { 'organisation' => 'government-organisation:OT1178', 'government-domain' => 'aa' }
      expect(data_validator.get_form_errors(params, field_definitions, 'government-domain', nil, @registers_client).details).to be_empty
    end

    it 'returns an error if key does not exist' do
      params = { 'organisation' => 'government-organisation:FAILME', 'government-domain' => 'aa' }
      expect(data_validator.get_form_errors(params, field_definitions, 'government-domain', nil, @registers_client).details).to eql('organisation': [error: 'Must be valid data from a register that is ready to use'])
    end

    it 'returns an error if key is not in a valid format' do
      params = { 'organisation' => 'government-domain::', 'government-domain' => 'aa' }
      expect(data_validator.get_form_errors(params, field_definitions, 'government-domain', nil, @registers_client).details).to eql('organisation': [error: 'Must be valid data from a register that is ready to use'])
    end

    it 'returns no errors if curie is empty' do
      params = { 'organisation' => '', 'government-domain' => 'aa' }
      expect(data_validator.get_form_errors(params, field_definitions, 'government-domain', nil, @registers_client).details).to be_empty
    end
  end
end
