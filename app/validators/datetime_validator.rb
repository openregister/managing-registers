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

  def valid_date(value)
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