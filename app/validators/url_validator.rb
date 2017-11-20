class UrlValidator < ActiveModel::EachValidator
  def valid_url(value)
    uri = URI.parse(value)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS) && !uri.host.nil?
  end

  def validate_each(record, attribute, value)
    record.errors.add attribute, 'Enter a valid web address (including http:// or https://)' unless valid_url(value)
  end
end
