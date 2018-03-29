# frozen_string_literal: true

require 'rails_helper'


RSpec.feature 'Publish Record', type: :feature do
  before do
    stub_request(:post, 'https://api.notifications.service.gov.uk/v2/notifications/email')
      .to_return(status: 200, body: '{}')

    stub_request(:post, 'http://country.test.openregister.org/load-rsf')
      .with(body: /add-item	{"country":"zz","end-date":"2014-05","name":"name","official-name":"official name","start-date":"2014-05"}\nappend-entry	user	zz	\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z	sha-256:38dda0d017bff8c4c9090a723b8e423d267a15717896135d4ab0b38f87dec7d4/,
            headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Basic b3BlbnJlZ2lzdGVyOkxnanNBR3lIRTE=', 'Content-Type' => 'application/uk-gov-rsf' })
      .to_return(status: 200, body: '', headers: {})

    stub('https://country.register.gov.uk/download-rsf/0', './spec/support/country-full.rsf')
    stub('https://register.register.gov.uk/download-rsf/0', './spec/support/register.rsf')
    stub('https://country.register.gov.uk/download-rsf/207', './spec/support/country-207.rsf')
  end

  before :each do
    ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')
    expect(User.count).to eq(1)

    visit '/'
    expect(page).to have_content 'Sign in'
    fill_in 'Email', with: 'testuser@gov.uk'
    fill_in 'Password', with: 'password123'
    click_button 'Continue'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'as an admin' do
    create(:register, key: 'country')
    visit 'country/new'
    expect(page).to have_content 'country'
    fill_in 'country', with: 'zz'
    fill_in 'name', with: 'name'
    fill_in 'official-name', with: 'official name'
    fill_in 'start-date', with: '2014-05'
    fill_in 'end-date', with: '2014-05'
    click_button 'Continue'

    expect(page).to have_content 'Check your new record'
    check 'confirm_approve'
    click_button 'Submit'

    expect(page).to have_content 'The record has been published.'
  end
end
