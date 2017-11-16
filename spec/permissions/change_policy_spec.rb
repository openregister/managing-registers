# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Change Policy Permission', type: :feature do
  scenario 'show? allowed' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', true, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.show?(user, register.key)).to eq(true)
  end

  scenario 'show? allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.show?(user, register.key)).to eq(true)
  end

  scenario 'show? allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.show?(user, register.key)).to eq(true)
  end

  scenario 'show? not allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.show?(user, register.key)).to eq(false)
  end

  scenario 'show? not allowed not associated to the register' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.show?(user, 'random')).to eq(false)
  end

  scenario 'edit? allowed' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', true, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.edit?(user, register.key)).to eq(true)
  end

  scenario 'edit? allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.edit?(user, register.key)).to eq(true)
  end

  scenario 'edit? allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.edit?(user, register.key)).to eq(true)
  end

  scenario 'edit? not allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.edit?(user, register.key)).to eq(false)
  end

  scenario 'edit? not allowed not associated to the register' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.edit?(user, 'random')).to eq(false)
  end

  scenario 'destroy? allowed' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', true, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.destroy?(user, register.key)).to eq(true)
  end

  scenario 'destroy? allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.destroy?(user, register.key)).to eq(true)
  end

  scenario 'destroy? allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.destroy?(user, register.key)).to eq(true)
  end

  scenario 'destroy? not allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.destroy?(user, register.key)).to eq(false)
  end

  scenario 'destroy? not allowed not associated to the register' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.destroy?(user, 'random')).to eq(false)
  end

  scenario 'update? allowed' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', true, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.update?(user, register.key)).to eq(true)
  end

  scenario 'update? allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.update?(user, register.key)).to eq(true)
  end

  scenario 'update? allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.update?(user, register.key)).to eq(true)
  end

  scenario 'update? not allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.update?(user, register.key)).to eq(false)
  end

  scenario 'update? not allowed not associated to the register' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(ChangePolicy.update?(user, 'random')).to eq(false)
  end
end
