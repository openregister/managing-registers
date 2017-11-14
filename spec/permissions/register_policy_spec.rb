# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Register Policy Permission', type: :feature do

  scenario 'create_and_review? allowed' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', true, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.create_and_review?(user, register.key)).to eq(true)
  end

  scenario 'create_and_review? allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.create_and_review?(user, register.key)).to eq(true)
  end

  scenario 'create_and_review? allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.create_and_review?(user, register.key)).to eq(true)
  end

  scenario 'create_and_review? not allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.create_and_review?(user, register.key)).to eq(false)
  end

  scenario 'create_and_review? not allowed not associated to the register' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.create_and_review?(user, 'random')).to eq(false)
  end

  scenario 'create_pending_review? allowed' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', true, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.create_pending_review?(user, register.key)).to eq(true)
  end

  scenario 'create_pending_review? allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.create_pending_review?(user, register.key)).to eq(true)
  end

  scenario 'create_pending_review? allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.create_pending_review?(user, register.key)).to eq(true)
  end

  scenario 'create_pending_review? allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.create_pending_review?(user, register.key)).to eq(true)
  end

  scenario 'create_pending_review? not allowed not associated to the register' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.create_pending_review?(user, 'random')).to eq(false)
  end

  scenario 'confirm? allowed' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', true, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.confirm?(user, register.key)).to eq(true)
  end

  scenario 'confirm? allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.confirm?(user, register.key)).to eq(true)
  end

  scenario 'confirm? allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.confirm?(user, register.key)).to eq(true)
  end

  scenario 'confirm? allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.confirm?(user, register.key)).to eq(true)
  end

  scenario 'confirm? not allowed not associated to the register' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.confirm?(user, 'random')).to eq(false)
  end

  scenario 'new? allowed' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', true, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.new?(user, register.key)).to eq(true)
  end

  scenario 'new? allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.new?(user, register.key)).to eq(true)
  end

  scenario 'new? allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.new?(user, register.key)).to eq(true)
  end

  scenario 'new? allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.new?(user, register.key)).to eq(true)
  end

  scenario 'new? not allowed not associated to the register' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.new?(user, 'random')).to eq(false)
  end

  scenario 'view? allowed' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', true, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.view?(user, register.key)).to eq(true)
  end

  scenario 'view? allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.view?(user, register.key)).to eq(true)
  end

  scenario 'view? allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.view?(user, register.key)).to eq(true)
  end

  scenario 'view? allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.view?(user, register.key)).to eq(true)
  end

  scenario 'view? not allowed not associated to the register' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.view?(user, 'random')).to eq(false)
  end


  scenario 'update? allowed' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', true, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.update?(user, register.key)).to eq(true)
  end

  scenario 'update? allowed custodian' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'custodian', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.update?(user, register.key)).to eq(true)
  end

  scenario 'update? allowed advanced' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'advanced', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.update?(user, register.key)).to eq(true)
  end

  scenario 'update? allowed basic' do
    register = ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.update?(user, register.key)).to eq(true)
  end

  scenario 'update? not allowed not associated to the register' do
    ObjectsFactory.new.create_register('testuser@gov.uk', false, 'basic', 'country')
    user = User.find_by_email('testuser@gov.uk')

    expect(RegisterPolicy.update?(user, 'random')).to eq(false)
  end

end