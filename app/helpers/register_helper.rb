module RegisterHelper

  def get_description_for_register_field(field)
    OpenRegister.record('field', field, Rails.configuration.register_phase).text
  end

  def registers_by_name
    OpenRegister.register('register', Rails.configuration.register_phase)
      ._all_records
      .select { |item| not_system_register(item) }
      .map(&:key)
  end

  def not_system_register(item)
    %w{register datatype field}.none? { |type| type == format(item.key) }
  end

end
