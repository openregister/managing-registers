class RegisterController < ApplicationController

  include ApplicationHelper, RegisterHelper

  before_action :confirm, only: [:create]

  YEAR_MONTH_DAY_HOURS_MINUTES_SECONDS_UTC = '%Y-%m-%dT%H:%M:%SZ'.freeze
  YEAR_MONTH_DAY_HOURS_MINUTES_SECONDS = '%Y-%m-%dT%H:%M:%S'.freeze
  YEAR_MONTH_DAY = '%Y-%m-%d'.freeze
  YEAR_MONTH = '%Y-%m'.freeze
  YEAR = '%Y'.freeze

  DATE_FORMATS = [
      YEAR_MONTH_DAY_HOURS_MINUTES_SECONDS_UTC,
      YEAR_MONTH_DAY_HOURS_MINUTES_SECONDS,
      YEAR_MONTH_DAY,
      YEAR_MONTH,
      YEAR
  ].freeze

  def index
    @changes = Change.joins("LEFT OUTER JOIN statuses on statuses.change_id = changes.id")
                     .where("register_name = '#{params[:register]}' AND statuses.status = 'pending'")

    @register = get_register(params[:register])._all_records
    @register[0].try(:name) ? @register = @register.sort_by(&:name) : @register = @register.sort_by(&:key)
  end

  def new
    @register = get_register(params[:register])
    @form = JSON.parse(params.to_json)
  end

  def edit
    @changes = Change.joins("LEFT OUTER JOIN statuses on statuses.change_id = changes.id")
                     .where("register_name = '#{params[:register]}' AND statuses.status = 'pending'")
    @register = get_register(params[:register])

    if @changes.any? { |c| c.payload.value?(params[:id])}
      flash[:notice] = 'There is already a pending update on this record, this must be reviewed before creating another update'
      redirect_to registers_path
    end

    @form = convert_register_json(
        OpenRegister.record(params[:register].downcase, params[:id], :beta)
    ) if @form.nil?
  end

  def confirm
    errors = get_form_errors params
    if errors.present?
      errors.each { |k,v| flash[k] = v[:message] }
      @register = get_register(params[:register])
      @form = JSON.parse(params.to_json)
      render :new
    else
      return true if params[:data_confirmed]
      @register = get_register(params[:register])

      @current_register_record = OpenRegister.record(params[:register].downcase,
                          params[params[:register].downcase.to_sym],
                          :beta)

      if @current_register_record != nil
        @current_register_record = convert_register_json(@current_register_record)
      end

      render 'confirm'
      false
    end
  end

  def get_form_errors params
    result = {}
    fields = ['start-date', 'end-date']
    fields.each{ |field|
      unless params[field].blank?
        field_result = validate_date(params[field])
        unless field_result[:success]
          result[field] = field_result
        end
      end
    }
    result
  end

  def validate_date date
    parsed_date = nil

    DATE_FORMATS.each { |date_format|
      begin
        parsed_date = Date.strptime(date, date_format)
        return { success: true, value: parsed_date }
      rescue ArgumentError
      end
    }

    { success: false, message: "#{date} is not a valid date format" }
  end

  def create
    fields = get_register(params[:register]).fields

    payload = generate_canonical_object(fields, params)

    @change = Change.new(register_name: params[:register], payload: payload, user_id: current_user.id)
    @change.status = Status.new(status: 'pending')
    @change.save

    @change_approvers = Register.find_by(key: params[:register]).team.team_members.where.not(role: 'basic', user_id: current_user)

    if @change_approvers.present?
      RegisterUpdatesMailer.register_update_notification(@change, current_user, @change_approvers).deliver_now
    end

    RegisterUpdatesMailer.register_update_receipt(@change, current_user).deliver_now

    flash[:notice] = 'Your update has been submitted, you\'ll recieve a confirmation email once the update is live'
    redirect_to action: 'index', register: params[:register]
  end

end
