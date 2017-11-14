# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Teams Policy Permission', type: :feature do

  scenario 'show? allowed' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_id = Team.all.first.id

    expect(TeamsPolicy.show?(user, team_id)).to eq(true)
  end

  scenario 'show? not allowed' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect(TeamsPolicy.show?(user, 999)).to eq(false)
  end

  scenario 'index? allowed admin' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')

    expect(TeamsPolicy.index?(user)).to eq(true)
  end

  scenario 'index? allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')

    expect(TeamsPolicy.index?(user)).to eq(true)
  end

  scenario 'index? allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')

    expect(TeamsPolicy.index?(user)).to eq(true)
  end

  scenario 'index? allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')

    expect(TeamsPolicy.index?(user)).to eq(true)
  end

  scenario 'update? allowed admin' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')
    team_id = Team.all.first.id

    expect(TeamsPolicy.update?(user, team_id)).to eq(true)
  end

  scenario 'update? allowed admin no team relation' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')

    expect(TeamsPolicy.update?(user, 999)).to eq(true)
  end

  scenario 'update? allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_id = Team.all.first.id

    expect(TeamsPolicy.update?(user, team_id)).to eq(true)
  end

  scenario 'update? allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')
    team_id = Team.all.first.id

    expect(TeamsPolicy.update?(user, team_id)).to eq(true)
  end

  scenario 'update? not allowed no team relation' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect(TeamsPolicy.update?(user, 999)).to eq(false)
  end

  scenario 'update? not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')
    team_id = Team.all.first.id

    expect(TeamsPolicy.update?(user, team_id)).to eq(false)
  end

  scenario 'edit?? allowed admin' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')
    team_id = Team.all.first.id

    expect(TeamsPolicy.edit?(user, team_id)).to eq(true)
  end

  scenario 'edit? allowed admin no team relation' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')

    expect(TeamsPolicy.edit?(user, 999)).to eq(true)
  end

  scenario 'edit? allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_id = Team.all.first.id

    expect(TeamsPolicy.edit?(user, team_id)).to eq(true)
  end

  scenario 'edit? allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')
    team_id = Team.all.first.id

    expect(TeamsPolicy.edit?(user, team_id)).to eq(true)
  end

  scenario 'edit? not allowed no team relation' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect(TeamsPolicy.edit?(user, 999)).to eq(false)
  end

  scenario 'edit? not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')
    team_id = Team.all.first.id

    expect(TeamsPolicy.edit?(user, team_id)).to eq(false)
  end
end
