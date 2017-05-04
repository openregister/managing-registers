class RegisterController < ApplicationController
  include ApplicationHelper

  helper_method :prepare_register_name, :get_description_for_register_field

  @register_phase = Settings.register_phase

  before_action :confirm, only: [:create]


  # remove the idea of @register_name

  # @param [Object] register
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
    puts 'I am creating something'
  end

  def get_description_for_register_field(field)
    OpenRegister.record("field", field, @register_phase).text
  end

end