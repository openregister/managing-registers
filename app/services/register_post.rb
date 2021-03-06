# frozen_string_literal: true

class RegisterPost
  def self.call(register_name, rsf_body)
    protocol = Rails.configuration.register_ssl ? 'https' : 'http'
    uri = Rails.configuration.register_url.include?('localhost') ? URI("#{protocol}://#{Rails.configuration.register_url}") : URI("#{protocol}://#{register_name}.#{Rails.configuration.register_url}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = Rails.configuration.register_ssl

    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/uk-gov-rsf')
    request.basic_auth(
      Rails.application.secrets.register[:"#{register_name}"][:username],
      Rails.application.secrets.register[:"#{register_name}"][:password]
    )
    request.body = rsf_body

    http.request(request)
  end
end
