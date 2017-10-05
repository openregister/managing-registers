class RegisterPost
  attr_reader :register_name, :rsf_body

  def initialize(register_name, rsf_body)
    @register_name = register_name
    @rsf_body = rsf_body
  end

  def call
    protocol = Rails.configuration.register_ssl ? 'https' : 'http'
    (Rails.configuration.register_url.include? "localhost") ?
        uri = URI("#{protocol}://#{Rails.configuration.register_url}") :
        uri = URI("#{protocol}://#{register_name}.#{Rails.configuration.register_url}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = Rails.configuration.register_ssl

    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/uk-gov-rsf'})
    request.basic_auth(Rails.configuration.register_username, Rails.configuration.register_password)
    request.body = rsf_body

    http.request(request)
  end
end
