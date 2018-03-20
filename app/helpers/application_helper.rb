module ApplicationHelper
  def prepare_register_name(register_name)
    unless register_name.nil?
      register_name.tr('-', ' ').split * ' '
    end
  end

  def convert_register_json(record)
    record.item.value
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
