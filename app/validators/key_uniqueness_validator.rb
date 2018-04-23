class KeyUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    records = options[:records]
    is_create = options[:is_create]
    if ActiveModel::Type::Boolean.new.cast(is_create)
      if records.any? { |r| r.entry.key == value }
        record.errors.add attribute, 'This code is already in use for another record, please use another code'
      end
    end
  end
end
