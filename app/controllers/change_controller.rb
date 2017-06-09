class ChangeController < ApplicationController

  include ApplicationHelper

  def show
    @change = Change.find(params['id'])
    @register = get_register(@change.register_name)
    @new_register_record = @change.payload
    @current_register_record = OpenRegister.record(@change.register_name,
                                                   @change.payload[@change.register_name],
                                                   @register_phase)
    if @current_register_record != nil
      @current_register_record = convert_register_json(@current_register_record)
    end
  end

  def edit
    puts "hello"
    if params[:approve] == 'yes'
      @change = Change.find(params['id'])
      @register = get_register(@change.register_name)
      @new_register_record = @change.payload
      @current_register_record = OpenRegister.record(@change.register_name,
                                                     @change.payload[@change.register_name],
                                                     @register_phase)
      if @current_register_record != nil
        @current_register_record = convert_register_json(@current_register_record)
      end
    else
      @change_user = Change.find(params['id']).user
    end
  end

  def destroy
    status = Status.new(
      status: 'rejected',
      comment: params[:comments],
      reviewed_by_id: current_user.id
    )
    change = Change.find(params['id']).status = status
    change.save

    # TODO: Need to send email

    flash[:notice] = 'An email has been sent to the user about the rejection.'
    redirect_to controller: 'register', action: 'index', register: Change.find(params['id']).register_name
  end

  def update
    change = Change.find(params['id'])

    rsf_body = create_rsf(change.payload, change.register_name)
    response = post_to_register(params[:register], rsf_body)

    if response.code == '200'
      status = Status.new(status: 'approved', reviewed_by_id: current_user.id)
      change = change.status = status
      change.save

      flash[:notice] = 'The record has been published.'
    else
      flash[:notice] = 'We had an issue updating the register, try again.'
    end

    # TODO: Need to send email

    redirect_to controller: 'register', action: 'index', register: Change.find(params['id']).register_name
  end

  def post_to_register(register_name, rsf_body)
    protocol = Rails.configuration.register_ssl ? protocol = 'https' : protocol = 'http'

    (Rails.configuration.register_url.include? "localhost") ?
        uri = URI(protocol + '://' + Rails.configuration.register_url) :
        uri = URI(protocol + '://' + register_name + '.' + Rails.configuration.register_url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = Rails.configuration.register_ssl

    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/uk-gov-rsf'})
    request.basic_auth(Rails.configuration.register_username, Rails.configuration.register_password)
    request.body = rsf_body

    http.request(request)
  end

  def create_rsf(payload, register_name)
    payload_sha = Digest::SHA256.hexdigest payload.to_json
    current_date_register_format = DateTime.now.strftime("%Y-%m-%dT%H:%M:%SZ")
    record_key = payload[register_name]

    item = "add-item\t#{payload.to_json}"
    entry = "append-entry\tuser\t#{record_key}\t#{current_date_register_format}\tsha-256:#{payload_sha}"

    "#{item}\n#{entry}"
  end

end