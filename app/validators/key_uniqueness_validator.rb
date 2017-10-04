class KeyUniquenessValidator < ActiveModel::Validator
  def validate(record)
    key = options[:register_name]
    records = options[:records]
    is_create = options[:is_create]
    if ActiveModel::Type::Boolean.new.cast(is_create)
      register_sym = key.underscore.to_sym
      key_param = record.instance_variable_get("@#{key.underscore}")
      if records.select {|r| r[:item][key] == key_param}.present?
        record.errors.add register_sym, 'This code is already in use for another record, please use another code'
      end
    end
  end
end