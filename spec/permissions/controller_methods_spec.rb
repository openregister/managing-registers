# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Controller Methods', type: :feature do
  let(:controller_methods) { Class.new.extend(Permissions::ControllerMethods) }

  scenario 'Admin can perform general actions' do
    actions = %i[
      REGISTER_INDEX
      REGISTER_NEW
      REGISTER_EDIT
      REGISTER_CONFIRM
      REGISTER_CREATE_PENDING_REVIEW
      REGISTER_CREATE_AND_REVIEW
      USERS_ADMIN
      USERS_CUSTODIANS
      USERS_CREATE
      CHANGE_SHOW
      CHANGE_EDIT
      CHANGE_DESTROY
      CHANGE_UPDATE
    ]

    register = ObjectsFactory.new.create_register('testuser@gov.uk', true, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    actions.each do |action|
      expect { controller_methods.check_permissions(action, current_user: user, register_name: register.key) }
        .not_to raise_error, "admin unable to perform action #{action}"
    end
  end

  scenario 'Admin can perform team actions' do
    actions = %i[
      TEAM_MEMBERS_EDIT
      TEAM_MEMBERS_UPDATE
      TEAM_MEMBERS_DESTROY
      TEAMS_INDEX
      TEAMS_SHOW
      TEAMS_EDIT
      TEAMS_UPDATE
    ]

    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')
    team_id = TeamMember.first.team_id
    team_member_id = TeamMember.first.id

    actions.each do |action|
      expect { controller_methods.check_permissions(action, current_user: user, team_id: team_id, team_member_id: team_member_id) }
        .not_to raise_error, "admin unable to perform action #{action}"
    end
  end

  scenario 'check_permissions REGISTER_INDEX allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_INDEX, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_INDEX allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_INDEX, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_INDEX not allowed' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_INDEX, current_user: user, register_name: 'ramdon') }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions REGISTER_INDEX not allowed basic' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_INDEX, current_user: user, register_name: 'ramdon') }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions REGISTER_NEW allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_NEW, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_NEW allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_NEW, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_NEW not allowed' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_NEW, current_user: user, register_name: 'random') }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions REGISTER_NEW allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_NEW, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_EDIT allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_EDIT, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_EDIT allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_EDIT, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_EDIT allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_EDIT, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_EDIT not allowed' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_EDIT, current_user: user, register_name: 'random') }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions REGISTER_CONFIRM allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_CONFIRM, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_CONFIRM allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_CONFIRM, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_CONFIRM allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_CONFIRM, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_CONFIRM not allowed' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_CONFIRM, current_user: user, register_name: 'random') }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions REGISTER_CREATE_PENDING_REVIEW allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_CREATE_PENDING_REVIEW, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_CREATE_PENDING_REVIEW allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_CREATE_PENDING_REVIEW, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_CREATE_PENDING_REVIEW allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_CREATE_PENDING_REVIEW, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_CREATE_PENDING_REVIEW not allowed' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_CREATE_PENDING_REVIEW, current_user: user, register_name: 'random') }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions REGISTER_CREATE_AND_REVIEW allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_CREATE_AND_REVIEW, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_CREATE_AND_REVIEW allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_CREATE_AND_REVIEW, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions REGISTER_CREATE_AND_REVIEW not allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_CREATE_AND_REVIEW, current_user: user, register_name: register.key) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions REGISTER_CREATE_AND_REVIEW not allowed' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:REGISTER_CREATE_AND_REVIEW, current_user: user, register_name: 'random') }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions TEAM_MEMBERS_EDIT allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_id = TeamMember.first.team_id
    team_member_id = TeamMember.first.id

    expect { controller_methods.check_permissions(:TEAM_MEMBERS_EDIT, current_user: user, team_id: team_id, team_member_id: team_member_id) }
      .not_to raise_error
  end

  scenario 'check_permissions TEAM_MEMBERS_EDIT allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')
    team_id = TeamMember.first.team_id
    team_member_id = TeamMember.first.id

    expect { controller_methods.check_permissions(:TEAM_MEMBERS_EDIT, current_user: user, team_id: team_id, team_member_id: team_member_id) }
      .not_to raise_error
  end

  scenario 'check_permissions TEAM_MEMBERS_EDIT not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')
    team_id = TeamMember.first.team_id
    team_member_id = TeamMember.first.id

    expect { controller_methods.check_permissions(:TEAM_MEMBERS_EDIT, current_user: user, team_id: team_id, team_member_id: team_member_id) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions TEAM_MEMBERS_EDIT not allowed' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_member_id = TeamMember.first.id

    expect { controller_methods.check_permissions(:TEAM_MEMBERS_EDIT, current_user: user, team_id: 999, team_member_id: team_member_id) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions TEAM_MEMBERS_EDIT not allowed' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:TEAM_MEMBERS_EDIT, current_user: user, team_id: team_id, team_member_id: 999) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions TEAM_MEMBERS_UPDATE allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_member_id = TeamMember.first.id

    expect { controller_methods.check_permissions(:TEAM_MEMBERS_UPDATE, current_user: user, team_member_id: team_member_id) }
      .not_to raise_error
  end

  scenario 'check_permissions TEAM_MEMBERS_UPDATE allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')
    team_member_id = TeamMember.first.id

    expect { controller_methods.check_permissions(:TEAM_MEMBERS_UPDATE, current_user: user, team_member_id: team_member_id) }
      .not_to raise_error
  end

  scenario 'check_permissions TEAM_MEMBERS_UPDATE not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')
    team_member_id = TeamMember.first.id

    expect { controller_methods.check_permissions(:TEAM_MEMBERS_UPDATE, current_user: user, team_member_id: team_member_id) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions TEAM_MEMBERS_UPDATE not allowed' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect { controller_methods.check_permissions(:TEAM_MEMBERS_UPDATE, current_user: user, team_member_id: 999) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions TEAM_MEMBERS_DESTROY allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_id = TeamMember.first.team_id
    team_member_id = TeamMember.first.id

    expect { controller_methods.check_permissions(:TEAM_MEMBERS_DESTROY, current_user: user, team_id: team_id, team_member_id: team_member_id) }
      .not_to raise_error
  end

  scenario 'check_permissions TEAM_MEMBERS_DESTROY allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')
    team_id = TeamMember.first.team_id
    team_member_id = TeamMember.first.id

    expect { controller_methods.check_permissions(:TEAM_MEMBERS_DESTROY, current_user: user, team_id: team_id, team_member_id: team_member_id) }
      .not_to raise_error
  end

  scenario 'check_permissions TEAM_MEMBERS_DESTROY not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')
    team_id = TeamMember.first.team_id
    team_member_id = TeamMember.first.id

    expect { controller_methods.check_permissions(:TEAM_MEMBERS_DESTROY, current_user: user, team_id: team_id, team_member_id: team_member_id) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions TEAM_MEMBERS_DESTROY not allowed' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_member_id = TeamMember.first.id

    expect { controller_methods.check_permissions(:TEAM_MEMBERS_DESTROY, current_user: user, team_id: 999, team_member_id: team_member_id) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions TEAM_MEMBERS_DESTROY not allowed' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:TEAM_MEMBERS_DESTROY, current_user: user, team_id: team_id, team_member_id: 999) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions TEAMS_INDEX allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect { controller_methods.check_permissions(:TEAMS_INDEX, current_user: user) }
      .not_to raise_error
  end

  scenario 'check_permissions TEAMS_INDEX allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')

    expect { controller_methods.check_permissions(:TEAMS_INDEX, current_user: user) }
      .not_to raise_error
  end

  scenario 'check_permissions TEAMS_INDEX allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')

    expect { controller_methods.check_permissions(:TEAMS_INDEX, current_user: user) }
      .not_to raise_error
  end

  scenario 'check_permissions TEAMS_SHOW allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:TEAMS_SHOW, current_user: user, team_id: team_id) }
      .not_to raise_error
  end

  scenario 'check_permissions TEAMS_SHOW allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:TEAMS_SHOW, current_user: user, team_id: team_id) }
      .not_to raise_error
  end

  scenario 'check_permissions TEAMS_SHOW allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:TEAMS_SHOW, current_user: user, team_id: team_id) }
      .not_to raise_error
  end

  scenario 'check_permissions TEAMS_SHOW not allowed' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect { controller_methods.check_permissions(:TEAMS_SHOW, current_user: user, team_id: 999) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions TEAMS_UPDATE allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:TEAMS_UPDATE, current_user: user, team_id: team_id) }
      .not_to raise_error
  end

  scenario 'check_permissions TEAMS_UPDATE allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:TEAMS_UPDATE, current_user: user, team_id: team_id) }
      .not_to raise_error
  end

  scenario 'check_permissions TEAMS_UPDATE not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:TEAMS_UPDATE, current_user: user, team_id: team_id) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions TEAMS_UPDATE not allowed' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect { controller_methods.check_permissions(:TEAMS_UPDATE, current_user: user, team_id: 999) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions TEAMS_EDIT allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:TEAMS_EDIT, current_user: user, team_id: team_id) }.not_to raise_error
  end

  scenario 'check_permissions TEAMS_EDIT allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:TEAMS_EDIT, current_user: user, team_id: team_id) }
      .not_to raise_error
  end

  scenario 'check_permissions TEAMS_EDIT not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:TEAMS_EDIT, current_user: user, team_id: team_id) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions TEAMS_EDIT not allowed' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect { controller_methods.check_permissions(:TEAMS_EDIT, current_user: user, team_id: 999) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions USERS_ADMIN not allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect { controller_methods.check_permissions(:USERS_ADMIN, current_user: user) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions USERS_ADMIN not allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')

    expect { controller_methods.check_permissions(:USERS_ADMIN, current_user: user) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions USERS_ADMIN not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')

    expect { controller_methods.check_permissions(:USERS_ADMIN, current_user: user) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions USERS_CUSTODIANS allowed' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')

    expect { controller_methods.check_permissions(:USERS_CUSTODIANS, current_user: user) }
      .not_to raise_error
  end

  scenario 'check_permissions USERS_CUSTODIANS not allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect { controller_methods.check_permissions(:USERS_CUSTODIANS, current_user: user) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions USERS_CUSTODIANS not allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')

    expect { controller_methods.check_permissions(:USERS_CUSTODIANS, current_user: user) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions USERS_CUSTODIANS not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')

    expect { controller_methods.check_permissions(:USERS_CUSTODIANS, current_user: user) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions USERS_SHOW allowed' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect { controller_methods.check_permissions(:USERS_SHOW, current_user: user, user: user) }
      .not_to raise_error
  end

  scenario 'check_permissions USERS_SHOW not allowed' do
    user1 = ObjectsFactory.new.create_user_with_team('testuser1@gov.uk', false, 'custodian')
    user2 = ObjectsFactory.new.create_user_with_team('testuser2@gov.uk', false, 'custodian')

    expect { controller_methods.check_permissions(:USERS_SHOW, current_user: user1, user: user2) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions USERS_NEW allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:USERS_NEW, current_user: user, role: 'custodian', team_id: team_id) }
      .not_to raise_error
  end

  scenario 'check_permissions USERS_NEW allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:USERS_NEW, current_user: user, role: 'custodian', team_id: team_id) }
      .not_to raise_error
  end

  scenario 'check_permissions USERS_NEW allowed admin' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:USERS_NEW, current_user: user, role: 'custodian', team_id: team_id) }
      .not_to raise_error
  end

  scenario 'check_permissions USERS_NEW not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:USERS_NEW, current_user: user, role: 'custodian', team_id: team_id) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions USERS_NEW not allowed role not present' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', true, 'custodian')
    team_id = TeamMember.first.team_id

    expect { controller_methods.check_permissions(:USERS_NEW, current_user: user, team_id: team_id) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions USERS_NEW not allowed team not present' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')

    expect { controller_methods.check_permissions(:USERS_NEW, current_user: user, role: 'custodian') }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions USERS_CREATE allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect { controller_methods.check_permissions(:USERS_CREATE, current_user: user, user: user) }
      .not_to raise_error
  end

  scenario 'check_permissions USERS_CREATE allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')

    expect { controller_methods.check_permissions(:USERS_CREATE, current_user: user, user: user) }
      .not_to raise_error
  end

  scenario 'check_permissions USERS_CREATE not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')

    expect { controller_methods.check_permissions(:USERS_CREATE, current_user: user, user: user) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions USERS_DESTROY not allowed custodian' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'custodian')

    expect { controller_methods.check_permissions(:USERS_DESTROY, current_user: user) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions USERS_DESTROY not allowed advanced' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'advanced')

    expect { controller_methods.check_permissions(:USERS_DESTROY, current_user: user) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions USERS_DESTROY not allowed basic' do
    user = ObjectsFactory.new.create_user_with_team('testuser@gov.uk', false, 'basic')

    expect { controller_methods.check_permissions(:USERS_DESTROY, current_user: user) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions CHANGE_SHOW allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:CHANGE_SHOW, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions CHANGE_SHOW allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:CHANGE_SHOW, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions CHANGE_SHOW not allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:CHANGE_SHOW, current_user: user, register_name: register.key) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions CHANGE_SHOW not allowed' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:CHANGE_SHOW, current_user: user, register_name: 'random') }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions CHANGE_EDIT allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:CHANGE_EDIT, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions CHANGE_EDIT allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:CHANGE_EDIT, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions CHANGE_EDIT not allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:CHANGE_EDIT, current_user: user, register_name: register.key) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions CHANGE_EDIT not allowed' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:CHANGE_EDIT, current_user: user, register_name: 'random') }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions CHANGE_DESTROY allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:CHANGE_DESTROY, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions CHANGE_DESTROY allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', true, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:CHANGE_DESTROY, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions CHANGE_DESTROY not allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:CHANGE_DESTROY, current_user: user, register_name: register.key) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions CHANGE_UPDATE allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:CHANGE_UPDATE, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions CHANGE_UPDATE allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:CHANGE_UPDATE, current_user: user, register_name: register.key) }
      .not_to raise_error
  end

  scenario 'check_permissions CHANGE_UPDATE not allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:CHANGE_UPDATE, current_user: user, register_name: register.key) }
      .to raise_error(PermissionError)
  end

  scenario 'check_permissions CHANGE_UPDATE not allowed' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect { controller_methods.check_permissions(:CHANGE_UPDATE, current_user: user, register_name: 'random') }
      .to raise_error(PermissionError)
  end
end
