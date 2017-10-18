class KeyUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    records = options[:records]
    is_create = options[:is_create]
    key = attribute.to_s.dasherize
    if ActiveModel::Type::Boolean.new.cast(is_create)
      if records.select { |r| r[:item][key] == value }.present?
        record.errors.add attribute, 'This code is already in use for another record, please use another code'
      end
    end
  end
end
