module ApplicationHelper

  def prepare_register_name(registerName)
    unless registerName.nil?
      registerName.gsub('-', ' ').split.map(&:capitalize) * ' '
    end
  end

  def convert_register_json(register)
    converted_json = JSON.parse(register.to_json)
    converted_json.keys.each do |key|
      if key.include? '_'
        converted_json[key.gsub('_', '-')] = converted_json[key];
        converted_json.delete(key);
      end
    end
    converted_json
  end

  def get_register(register_name)
    OpenRegister.register(register_name.downcase, @register_phase)
  end

end
