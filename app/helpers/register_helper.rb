module RegisterHelper

  def get_description_for_register_field(field)
    OpenRegister.record('field', field, :beta).text
  end

  def beta_registers_by_name
    OpenRegister.register('register', :beta)._all_records.map(&:key)
  end

end
