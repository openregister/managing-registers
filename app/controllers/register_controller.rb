class RegisterController < ApplicationController

  include ApplicationHelper
  helper_method :prepare_register_name, :get_description_for_register_field

  @register_phase = Settings.register_phase

  before_action :confirm, only: [:create]

  def index
    @register = get_register(params[:register])._all_records
    @register[0].try(:name) ? @register = @register.sort_by(&:name) : @register = @register.sort_by(&:key)
  end

  def new
    @register = get_register(params[:register])
    @form = JSON.parse(params.to_json)
    render 'form'
  end

  def edit
    @register = get_register(params[:register])

    @form = convert_register_json(
        OpenRegister.record(params[:register].downcase, params[:key], @register_phase)
    ) if @form.nil?
    render 'form'
  end

  def confirm
    return true if params[:data_confirmed]
    @register = get_register(params[:register])

    @current_register_record = OpenRegister.record(params[:register].downcase,
                        params[params[:register].downcase.to_sym],
                        @register_phase)

    if @current_register_record != nil
      @current_register_record = convert_register_json(@current_register_record)
    end

    render 'confirm'
    false
  end

  def create
    fields = @register = get_register(params[:register]).fields

    payload = generate_canonical_object(fields, params)
    rsf_body = create_rsf(payload, params)
    response = post_to_register(rsf_body)

    if response.code == '200'
      flash[:notice] = 'Your update has been submitted, you\'ll recieve a confirmation email once the change is live'
      redirect_to controller: 'home', action: 'index'
    else
      flash[:notice] = 'Your update unfortunately failed, if the issue persists, please contact the register design authority'
      redirect_to controller: 'home', action: 'index'
    end
  end

  def get_description_for_register_field(field)
    OpenRegister.record('field', field, @register_phase).text
  end

  def post_to_register(rsf_body)
    uri = URI('http://localhost:8080/load-rsf')
    http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/uk-gov-rsf'})
    request.basic_auth('foo', 'bar')
    request.body = rsf_body

    http.request(request)
  end

  def create_rsf(payload, params)
    payload_sha = Digest::SHA256.hexdigest payload.to_json
    current_date_register_format = DateTime.now.strftime("%Y-%m-%dT%H:%M:%SZ")
    record_key = params[params[:register].to_sym].to_s

    item = "add-item\t#{payload.to_json}"
    entry = "append-entry\t#{current_date_register_format}\tsha-256:#{payload_sha}\t#{record_key}"

    "#{item}\n#{entry}"
  end

  def generate_canonical_object(fields, params)
    payload = {}
    fields.sort.each do |field|
      if params[field.to_sym].nil? != true && params[field.to_sym].empty? != true
        payload[field] = params[field.to_sym].to_s
      end
    end
    payload
  end

  def get_register(register_name)
    OpenRegister.register(register_name.downcase, @register_phase)
  end

end