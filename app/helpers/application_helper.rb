module ApplicationHelper

  def prepare_register_name(registerName)
    unless registerName.nil?
      registerName.gsub('-', ' ').split.map(&:capitalize) * ' '
    end
  end

end
