class LinkedValidator < ActiveModel::EachValidator
  DELIMITER = ':'.freeze

  def validate_each(record, attribute, value)
    register_linked = options[:register_linked]
    record.errors.add attribute, 'Must be valid data from a register that is ready to use' unless validate_linked(value, register_linked)
  end

  def validate_linked(value, register_linked)
    return false unless valid_value?(value)

    if value.include? DELIMITER
      check_curie(value)
    else
      check_register(value, register_linked)
    end
  end

  def check_curie(value)
    values = value.split(DELIMITER)

    valid_key?(values[0], values[1])
  end

  def check_register(value, register_linked)
    register_linked.present? && valid_key?(register_linked, value)
  end

  def valid_key?(register_name, key)
    current_register_record = OpenRegister.record(register_name, key, Rails.configuration.register_phase)
    !current_register_record.nil?
  rescue => e
    return false
  end

  def valid_value?(value)
    return true unless value.include? DELIMITER
    value.match?(/\A[\w-]+:\w+\z/)
  end

  private
end
