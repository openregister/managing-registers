class UrlValidator < ActiveModel::EachValidator
  def valid_url(value)
  uri = URI.parse(value)
  uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS) && !uri.host.nil?
  end

  def validate_each(record, attribute, value)
    record.errors.add attribute, "#{value} is not a valid URL" unless valid_url(value)
  end
end