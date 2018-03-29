module RegisterHelper
  def get_description_for_register_field(field)
    OpenRegister.record('field', field, Rails.configuration.register_phase).text
  end

  def registers_by_name
    register_data = @registers_client.get_register('register', Rails.configuration.register_phase)
    register_data.get_records
                 .select { |record| not_system_register(record.entry) }
                 .sort_by { |record| record.entry.key }
  end

  def not_system_register(entry)
    %w{register datatype field}.none? { |type| type == format(entry.key) }
  end
end
