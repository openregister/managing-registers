module RegisterHelper

  def get_description_for_register_field(field)
    OpenRegister.record('field', field, @register_phase).text
  end

  def beta_registers_by_name
    OpenRegister.register('register', Rails.configuration.register_phase)._all_records.map(&:key)
  end

end
