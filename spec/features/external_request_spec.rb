require 'spec_helper'

feature 'External request' do
  it 'Queries register register on register.gov.uk' do
    uri = URI('https://register.register.gov.uk/')

    response = Net::HTTP.get(uri)

    expect(response).to be_an_instance_of(String)
  end
end
