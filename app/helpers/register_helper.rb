module RegisterHelper

  def get_description_for_register_field(field)
    OpenRegister.record('field', field, @register_phase).text
  end

end
