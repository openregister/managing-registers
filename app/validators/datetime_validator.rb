require 'timeliness'

class DatetimeValidator < ActiveModel::EachValidator
  YEAR_MONTH_DAY_HOURS_MINUTES_SECONDS_UTC = 'yyyy-mm-ddThh:nn:ssZ'.freeze
  YEAR_MONTH_DAY_HOURS_MINUTES_SECONDS = 'yyyy-mm-ddThh:nn:ss'.freeze
  YEAR_MONTH_DAY = 'yyyy-mm-dd'.freeze
  YEAR_MONTH = 'yyyy-mm'.freeze
  YEAR = 'yyyy'.freeze
  DATE_FORMATS = [
      YEAR_MONTH_DAY_HOURS_MINUTES_SECONDS_UTC,
      YEAR_MONTH_DAY_HOURS_MINUTES_SECONDS,
      YEAR_MONTH_DAY,
      YEAR_MONTH,
      YEAR
  ].freeze

  def valid_date(value)
    DATE_FORMATS.any? { |f| Timeliness.parse(value, format: f) }
  end

  def validate_each(record, attribute, value)
    record.errors.add attribute, 'Enter a valid date' unless valid_date(value)
  end
end
