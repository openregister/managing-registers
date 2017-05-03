module ApplicationHelper

  def prepare_register_name(registerName)
    unless registerName.nil?
      registerName.gsub('-', ' ').split.map(&:capitalize) * ' '
    end
  end

  def get_all_attribute_names_prettified(register_item)
    attribute_names = register_item.instance_variables
    attribute_names.delete(attribute_names.size)

    attribute_names.map! {|x| x.to_s.sub!('@', '').gsub('_', ' ').split.map(&:capitalize)*' '}
  end

end
