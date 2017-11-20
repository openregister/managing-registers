module ApplicationHelper
  def prepare_register_name(register_name)
    unless register_name.nil?
      register_name.tr('-', ' ').split.map(&:capitalize) * ' '
    end
  end

  def convert_register_json(register)
    converted_json = JSON.parse(register.to_json)
    converted_json.keys.each do |key|
      if key.include? '_'
        converted_json[key.tr('_', '-')] = converted_json[key];
        converted_json.delete(key);
      end
    end
    converted_json
  end

  def get_register(register_name)
    OpenRegister.register(register_name.downcase, Rails.configuration.register_phase)
  end

  def generate_canonical_object(fields, params)
    payload = {}
    fields.sort.each do |field|
      if params[field].nil? != true && params[field].empty? != true
        payload[field] = params[field].to_s
      end
    end
    payload
  end
end
