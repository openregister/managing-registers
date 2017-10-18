class DatetimeValidator < ActiveModel::EachValidator
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

  def is_valid_length(value)
    [4, 7, 10, 19, 20].include?(value.length)
  end

  def starts_and_ends_with_number(value)
    !!(value =~ /\A\d/i) && !!(value =~ /\d\z/i)
  end

  def starts_with_number_ends_with_z_iso_length(value)
    !!(value =~ /\A\d/i) && value.length == 20 && value.end_with?('Z')
  end

  def valid_date(value)
    unless is_valid_length(value) && starts_and_ends_with_number(value) || starts_with_number_ends_with_z_iso_length(value)
      return false
    end

    DATE_FORMATS.each { |date_format|
      begin
        Date.strptime(value, date_format)
        return true
      rescue ArgumentError
      end
    }
    false
  end

  def validate_each(record, attribute, value)
    record.errors.add attribute, 'Enter a valid date' unless valid_date(value)
  end
end
