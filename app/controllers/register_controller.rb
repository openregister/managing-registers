class RegisterController < ApplicationController
  include ApplicationHelper

  helper_method :prepare_register_name, :get_description_for_register_field

  @register_phase = Settings.register_phase

  before_action :confirm, only: [:create]

  # remove the idea of @register_name from this class
  def index
    @register_name = params[:register]
    @register = OpenRegister.register(params[:register].downcase, @register_phase)
                            ._all_records

    @register[0].try(:name) ? @register = @register.sort_by(&:name) : @register = @register.sort_by(&:key)
  end

  def new
    @register_name = params[:register]
    @register = OpenRegister.register(params[:register].downcase, @register_phase)

    render 'form'
  end

  def edit
    @register_name = params[:register]
    @register = OpenRegister.register(params[:register].downcase, @register_phase)
    @form = OpenRegister.record(params[:register].downcase, params[:key], @register_phase)

    render 'form'
  end

  def confirm

    return true if params[:data_confirmed]

    @register_name = params[:register]
    @register = OpenRegister.register(params[:register].downcase, @register_phase)
    @current_register_record = OpenRegister.record(params[:register].downcase,
                                                   params[params[:register].downcase.to_sym],
                                           @register_phase)
    render 'confirm'
    false
  end

  def create
    fields = OpenRegister.register(params[:register].downcase, @register_phase).fields
    payload = {}

    fields.sort.each do |field|
      if params[field.to_sym].nil? != true && params[field.to_sym].empty? != true
        payload[field] = params[field.to_sym].to_s
      end
    end

    payload_sha = Digest::SHA256.hexdigest payload.to_json

    item = "add-item\t#{payload.to_json}"
    entry = "append-entry\t#{DateTime.now.strftime("%Y-%m-%dT%H:%M:%SZ")}\tsha-256:#{payload_sha}\t#{params[params[:register].to_sym].to_s}"

    rsf = "#{item}\n#{entry}"

    uri = URI('http://localhost:8080/load-rsf')

    http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/uk-gov-rsf'})
    request.basic_auth('foo', 'bar')
    request.body = rsf

    response = http.request(request)

    puts 'I am creating something'
  end

  def get_description_for_register_field(field)
    OpenRegister.record("field", field, @register_phase).text
  end


end