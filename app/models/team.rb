class Team < ApplicationRecord
  has_many :team_members
  has_many :registers
  has_many :users, through: :team_members

  def custodian
    team_members.where(role: 'custodian').first.user
  end

  def update_registers(updated_register_keys)
    current_registers = registers.collect{|register| register.key}

    registers_to_add = updated_register_keys.reject { |register| current_registers.include? register }
    registers_to_remove = current_registers.reject { |register| updated_register_keys.include? register }

    registers_to_remove.each{ |register_key| registers.delete(Register.find_by_key(register_key)) }

    registers_to_add.each do |register_key|
      new_register = Register.find_by_key(register_key)
      new_register = Register.new(key: register_key) if new_register.nil?
      registers << new_register
    end

    self
  end

end
