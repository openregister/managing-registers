require 'spec_helper'

feature 'External request' do
  it 'Queries register register on beta.openregister.org' do
    uri = URI('https://register.beta.openregister.org/')

    response = Net::HTTP.get(uri)

    expect(response).to be_an_instance_of(String)
  end
end
