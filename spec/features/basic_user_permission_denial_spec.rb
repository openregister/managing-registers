# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Basic User Permissions', type: :feature do
  before :each do
    ObjectsFactory.new.create_user_with_team('basicuser@gov.uk', false, 'basic')
    expect(User.count).to eq(1)
    stub('https://register.register.gov.uk/download-rsf/0', './spec/support/register.rsf')

    visit '/'
    expect(page).to have_content 'Sign in'
    fill_in 'Email', with: 'basicuser@gov.uk'
    fill_in 'Password', with: 'password123'
    click_button 'Continue'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'basic user can not access unauthorized resources' do
    unauthorised_paths = ['/government-domain', '/users/invitation/new?role=admin', '/custodians', '/admin']

    unauthorised_paths.each do |path|
      visit(path)
      expect(page).to have_content 'You are not authorized to access this page.'
    end
  end
end
