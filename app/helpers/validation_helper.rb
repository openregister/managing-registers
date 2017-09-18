module ValidationHelper

  class DataValidator

    def initialize
      @validators = {
          'integer' => ValidationHelper::IntegerDatatype.new,
          'string' => ValidationHelper::StringDatatype.new,
          'point' => ValidationHelper::PointDatatype.new,
          'url' => ValidationHelper::UrlDatatype.new,
          'curie' => ValidationHelper::CurieDatatype.new,
          'datetime' => ValidationHelper::DateDatatype.new
      }.freeze
    end

    def get_form_errors(params, field_definitions)

      result = {}
      field_definitions.each{ |field|
        field_name = field[:item]['field']

        if params[field_name].present?
          datatype = field[:item]['datatype']
          field_result = @validators[datatype].validate(params[field_name])
          unless field_result[:success]
            result[field_name] = field_result
          end
        elsif field_name == params[:register]
          result[field_name] = { success: false, message: "Field #{field_name} is required" }
        end
      }
      result
    end
  end

  class Datatype
    def validation_success(value)
      { success: true, value: value}
    end

    def validation_failure(message)
      { success: false, message: message }
    end
  end

  class IntegerDatatype < Datatype
    def validate(value)
      begin
        Integer(value)
        validation_success(value)
      rescue ArgumentError
        validation_failure("#{value} is not a valid integer")
      end
    end
  end

  class StringDatatype < Datatype
    def validate(value)
      validation_success(value)
    end
  end

  class PointDatatype < Datatype
    def validate(value)
      validation_success(value)
    end
  end

  class UrlDatatype < Datatype
    def validate(value)
      begin
        uri = URI.parse(value)

        if ((uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)) && !uri.host.nil?)
          validation_success(url)
        else
          validation_failure("#{url} is not a valid URL")
        end
      rescue
        validation_failure("#{url} is not a valid URL")
      end
    end
  end

  class CurieDatatype < Datatype
    def validate(value)
      if curie !~ /^\w+:\w+$/
        validation_failure("#{value} is not a valid curie")
      else
        validation_success(value)
      end
    end
  end

  class DateDatatype < Datatype
    YEAR_MONTH_DAY_HOURS_MINUTES_SECONDS_UTC = '%Y-%m-%dT%H:%M:%SZ'
    YEAR_MONTH_DAY_HOURS_MINUTES_SECONDS = '%Y-%m-%dT%H:%M:%S'
    YEAR_MONTH_DAY = '%Y-%m-%d'
    YEAR_MONTH = '%Y-%m'
    YEAR = '%Y'
    DATE_FORMATS = [
        YEAR_MONTH_DAY_HOURS_MINUTES_SECONDS_UTC,
        YEAR_MONTH_DAY_HOURS_MINUTES_SECONDS,
        YEAR_MONTH_DAY,
        YEAR_MONTH,
        YEAR
    ].freeze

    def validate(value)
      parsed_date = nil

      DATE_FORMATS.each { |date_format|
        begin
          parsed_date = Date.strptime(value, date_format)
          return validation_success(parsed_date)
        rescue ArgumentError
        end
      }

      validation_failure("#{value} is not a valid date format")
    end
  end

end