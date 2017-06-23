class UsersController < ApplicationController

  include ElevatedPermissionsHelper
  before_action :set_user

  def admin
    @admin_users = User.where(admin: true)
                       .where.not(invitation_accepted_at: nil)

    @pending_users = User.where(admin: true)
                         .where(invitation_accepted_at: nil)

    authorize! :admin, @users
  end

  def custodians
    @custodians = User.joins(:team_members)
                      .where(team_members: { role: 'custodian' })
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = 'Your update has been successful'
      redirect_to team_path
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = 'User has been successful deleted'
    redirect_to root_path
  end

  def show; end

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

  include ElevatedPermissionsHelper

  def invite_resource(&block)
    ## skip sending emails on invite
    super do |u|
      u.skip_invitation = true
    end

    user = User.find_by_email(resource_params[:email])

    unless user.admin?
      if current_user.admin?
        if params[:user][:role] == 'custodian'
          registers = Array.new

          loop.with_index{|_, i|
            register_name = resource_params[:teams_attributes][i.to_s][:registers]

            unless register_name.nil?
              registers.push(register_name)
            end
            break if resource_params[:teams_attributes][(i + 1).to_s].nil?
          }

          registers = registers.uniq
          team = Team.new(registers: registers)
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
