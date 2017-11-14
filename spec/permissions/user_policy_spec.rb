# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User Policy Permission', type: :feature do

  scenario 'show? allowed' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect(UserPolicy.show?(user, user)).to eq(true)
  end

  scenario 'show? not allowed' do
    user1 = ObjectsFactory.new.create_user_with_team('testuser1@gov.uk', false, 'custodian')
    user2 = ObjectsFactory.new.create_user_with_team('testuser2@gov.uk', false, 'custodian')

    expect(UserPolicy.show?(user1, user2)).to eq(false)
  end

  scenario 'custodians? allowed' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')

    expect(UserPolicy.custodians?(user)).to eq(true)
  end

  scenario 'custodians? not allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect(UserPolicy.custodians?(user)).to eq(false)
  end

  scenario 'custodians? not allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')

    expect(UserPolicy.custodians?(user)).to eq(false)
  end

  scenario 'custodians? not allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')

    expect(UserPolicy.custodians?(user)).to eq(false)
  end

  scenario 'new? allowed to admin' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')
    team = Team.all

    expect(UserPolicy.new?(user, 'custodian', team.first.id)).to eq(true)
  end

  scenario 'new? allowed to custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team = Team.all

    expect(UserPolicy.new?(user, 'custodian', team.first.id)).to eq(true)
  end

  scenario 'new? allowed to advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')
    team = Team.all

    expect(UserPolicy.new?(user, 'custodian', team.first.id)).to eq(true)
  end

  scenario 'new? not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')
    team = Team.all

    expect(UserPolicy.new?(user, 'custodian', team.first.id)).to eq(false)
  end

  scenario 'create? allowed admin' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')

    expect(UserPolicy.create?(user)).to eq(true)
  end

  scenario 'create? allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect(UserPolicy.create?(user)).to eq(true)
  end

  scenario 'create? allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')

    expect(UserPolicy.create?(user)).to eq(true)
  end

  scenario 'create? allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')

    expect(UserPolicy.create?(user)).to eq(false)
  end
end
