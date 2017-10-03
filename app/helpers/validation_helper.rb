module ValidationHelper

  class KeyUniquenessValidator < ActiveModel::Validator
    def validate(record)
      key = options[:register_name]
      records = options[:records]
      is_create = options[:is_create]
      if ActiveModel::Type::Boolean.new.cast(is_create)
        register_sym = key.underscore.to_sym
        key_param = record.instance_variable_get("@#{key.underscore}")
        if records.select {|r| r[:item][key] == key_param}.present?
          record.errors.add register_sym, 'This record is already present'
        end
      end
    end
  end

  class DataValidator
    def get_form_errors(params, field_definitions, register_name, action, records)

      field_to_sym = ->(field){ field.underscore.to_sym }

      register_sym = field_to_sym.call(register_name)

      register_model_class = Class.new() do
        # This is required see: https://stackoverflow.com/a/14431888/238230
        def self.model_name
          ActiveModel::Name.new(self, nil, 'record')
        end
        include ActiveModel::Validations

        validates_with KeyUniquenessValidator, records: records, register_name: register_name, is_create: params[:is_create]
        field_definitions.each do |field|
          field_sym = field_to_sym.call(field[:item]['field'])
          attr_accessor field_sym
          is_key = field_sym == register_sym
          case field[:item]['datatype']
            # Custom validators are defined in app/validators
          when 'integer'
            validates field_sym, numericality: { only_integer: true, message: "%{value} is not an integer" }, allow_blank: true
          when 'curie'
            validates field_sym, format:{ with: /\A\w+:\w+\z/, message: "%{value} is not a valid curie"}, allow_blank: true
          when 'string'
            validates field_sym, presence: { message: "Field %{attribute} is required"}, allow_blank: !is_key
          when 'url'
            validates field_sym, url: true, allow_blank: true
          when 'datetime'
            validates field_sym, datetime: true, allow_blank: true
          end
        end
      end

      field_definitions_map = field_definitions.map{ |f| field_to_sym.call(f[:item]['field'])}
      record = register_model_class.new
      field_definitions_map.each do |f|
        value = params[f.to_s.dasherize]
        record.send(:"#{f}=", value)
      end
      record.valid?
      record.errors
    end
  end
end