# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Basic User Permissions', type: :feature do
  before :each do
    ObjectsFactory.new.create_user_with_team('basicuser@gov.uk', false, 'basic')
    expect(User.count).to eq(1)
    stub('https://register.register.gov.uk/record/register.tsv', './spec/support/register_register.tsv')
    stub('https://field.register.gov.uk/record/register.tsv', './spec/support/field_register.tsv')
    stub('https://field.register.gov.uk/record/text.tsv', './spec/support/text.tsv')
    stub('https://field.register.gov.uk/record/phase.tsv', './spec/support/phase.tsv')
    stub('https://field.register.gov.uk/record/registry.tsv', './spec/support/registry.tsv')
    stub('https://field.register.gov.uk/record/copyright.tsv', './spec/support/copyright.tsv')
    stub('https://field.register.gov.uk/record/fields.tsv', './spec/support/fields.tsv')
    stub('https://register.register.gov.uk/records.tsv', './spec/support/register_records.tsv')
    stub('https://field.register.gov.uk/record/name.tsv', './spec/support/field_name.tsv')
    stub('https://field.register.gov.uk/record/official-name.tsv', './spec/support/field_official_name.tsv')
    stub('https://field.register.gov.uk/record/citizen-names.tsv', './spec/support/field_citizen_name.tsv')
    stub('https://field.register.gov.uk/record/start-date.tsv', './spec/support/field_start_date.tsv')
    stub('https://field.register.gov.uk/record/end-date.tsv', './spec/support/field_end_date.tsv')
    stub('https://country.register.gov.uk/records.tsv', './spec/support/records.tsv')

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
