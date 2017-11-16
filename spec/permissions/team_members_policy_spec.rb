# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Team Members Policy Permission', type: :feature do
  scenario 'edit? allowed admin' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')
    team_id = TeamMember.first.team_id
    team_member_id = TeamMember.first.id

    expect(TeamMembersPolicy.edit?(user, team_id, team_member_id)).to eq(true)
  end

  scenario 'edit? allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_id = TeamMember.first.team_id
    team_member_id = TeamMember.first.id

    expect(TeamMembersPolicy.edit?(user, team_id, team_member_id)).to eq(true)
  end

  scenario 'edit? allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')
    team_id = TeamMember.first.team_id
    team_member_id = TeamMember.first.id

    expect(TeamMembersPolicy.edit?(user, team_id, team_member_id)).to eq(true)
  end

  scenario 'edit? not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')
    team_id = TeamMember.first.team_id
    team_member_id = TeamMember.first.id

    expect(TeamMembersPolicy.edit?(user, team_id, team_member_id)).to eq(false)
  end

  scenario 'edit? not allowed no team relation' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_member_id = TeamMember.first.id

    expect(TeamMembersPolicy.edit?(user, 999, team_member_id)).to eq(false)
  end

  scenario 'edit? not allowed no team_member relation' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_id = TeamMember.first.team_id

    expect(TeamMembersPolicy.edit?(user, team_id, 999)).to eq(false)
  end

  scenario 'update? allowed admin' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')
    team_member_id = TeamMember.first.id

    expect(TeamMembersPolicy.update?(user, team_member_id)).to eq(true)
  end

  scenario 'update? allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_member_id = TeamMember.first.id

    expect(TeamMembersPolicy.update?(user, team_member_id)).to eq(true)
  end

  scenario 'update? allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')
    team_member_id = TeamMember.first.id

    expect(TeamMembersPolicy.update?(user, team_member_id)).to eq(true)
  end

  scenario 'update? not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')
    team_member_id = TeamMember.first.id

    expect(TeamMembersPolicy.update?(user, team_member_id)).to eq(false)
  end

  scenario 'update? not allowed no team_member relation' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect(TeamMembersPolicy.update?(user, 999)).to eq(false)
  end

  scenario 'destroy? allowed admin' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')
    team_id = TeamMember.first.team_id
    team_member_id = TeamMember.first.id

    expect(TeamMembersPolicy.destroy?(user, team_id, team_member_id)).to eq(true)
  end

  scenario 'destroy? allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_id = TeamMember.first.team_id
    team_member_id = TeamMember.first.id

    expect(TeamMembersPolicy.destroy?(user, team_id, team_member_id)).to eq(true)
  end

  scenario 'destroy? allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')
    team_id = TeamMember.first.team_id
    team_member_id = TeamMember.first.id

    expect(TeamMembersPolicy.destroy?(user, team_id, team_member_id)).to eq(true)
  end

  scenario 'destroy? not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')
    team_id = TeamMember.first.team_id
    team_member_id = TeamMember.first.id

    expect(TeamMembersPolicy.destroy?(user, team_id, team_member_id)).to eq(false)
  end

  scenario 'destroy? not allowed no team relation' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_member_id = TeamMember.first.id

    expect(TeamMembersPolicy.destroy?(user, 999, team_member_id)).to eq(false)
  end

  scenario 'destroy? not allowed no team_member relation' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_id = TeamMember.first.team_id

    expect(TeamMembersPolicy.destroy?(user, team_id, 999)).to eq(false)
  end
end
