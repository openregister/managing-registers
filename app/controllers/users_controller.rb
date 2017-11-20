# frozen_string_literal: true

class UsersController < ApplicationController
  include ElevatedPermissionsHelper
  before_action :set_user

  def admin
    check_permissions(:USERS_ADMIN, current_user: current_user)

    @admin_users = User.where(admin: true)
                       .where.not(invitation_accepted_at: nil)

    @pending_users = User.where(admin: true)
                         .where(invitation_accepted_at: nil)
  end

  def custodians
    check_permissions(:USERS_CUSTODIANS, current_user: current_user)

    @custodians = User.joins(:team_members)
                      .where(team_members: { role: 'custodian' })
                      .where.not(invitation_accepted_at: nil)

    @pending_custodians = User.joins(:team_members)
                              .where(team_members: { role: 'custodian' })
                              .where(invitation_accepted_at: nil)
  end

  def update; end

  def destroy
    check_permissions(:USERS_DESTROY, current_user: current_user)

    @user.team_members.each { |team_member| TeamMember.destroy team_member.id }
    @user.destroy
    flash[:notice] = 'User has been successful deleted'

    redirect_to admin_path
  end

  def show
    check_permissions(:USERS_SHOW, current_user: current_user, user: @user)
  end

  def edit; end

private

  def set_user
    @user = User.find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit(:full_name, :email, :role, :admin, :password, :password_confirmation, :current_password, team_members_attributes: [:role])
  end
end

class UsersController::InvitationsController < Devise::InvitationsController
  def get_user
    User.find_by_email(resource_params[:email])
  end

  include ElevatedPermissionsHelper
  include Permissions::ControllerMethods

  def new
    check_permissions(:USERS_NEW, current_user: current_user, role: params[:role], team_id: params[:team_id])

    super
  end

  def create
    check_permissions(:USERS_CREATE, current_user: current_user)

    # TODO: use rails validators for these checks
    begin
      params.require(:user).require(:email)
    rescue ActionController::ParameterMissing
      flash[:alert] = 'Email address is required'
      redirect_to(after_invite_path_for(current_inviter)) && return
    end
    is_admin = current_inviter[:admin]
    unless is_admin
      begin
        params.require(:user).require(:team_members_attributes).require('0').require('role')
      rescue ActionController::ParameterMissing
        flash[:alert] = 'Permission Title is required'
        redirect_to(after_invite_path_for(current_inviter)) && return
      end
    end

    if get_user.try(:admin)
      flash[:alert] = 'You cannot invite an existing admin user'
      redirect_to(after_invite_path_for(current_inviter)) && return
    end

    super
  end

  def after_invite_path_for(_current_inviter)
    request_origin = request.referer
    uri = URI.parse(request_origin)
    params = CGI.parse(uri.query)
    role = params['role'].first

    return root_path unless role.present?

    if params['role'].first.to_s == 'admin'
      admin_path
    else
      custodians_path
    end
  end

  def invite_resource(&block)
    ## skip sending emails on invite
    super do |u|
      u.skip_invitation = true
    end

    user = get_user

    unless user.admin?
      if current_user.admin?
        if params[:user][:role] == 'custodian'

          registers ||= []

          resource_params[:teams_attributes].each_pair do |_index, field|
            registers.push(field['registers'].strip) unless field['registers'].nil?
          end

          registers = registers.uniq(&:key)
          team = Team.new.update_registers(registers)

          user.team_members.create(role: params[:user][:role], team: team).save
        else
          user.team_members.create(role: params[:user][:role]).save
        end
      else
        # update team_members because the invite save only saves user
        user.team_members.create(team_id: resource_params[:team_members_attributes]['0'][:team_id],
                                 role: resource_params[:team_members_attributes]['0'][:role]).save
      end
    end

    # send email with injected params
    user.deliver_invitation
    user
  end
end
