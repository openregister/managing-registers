class UsersController < ApplicationController

  include ElevatedPermissionsHelper
  before_action :set_user

  def admin
    @users = User.joins(:team_members)
                 .where(team_members: { role: 'admin' })
    authorize! :admin, @users
  end

  def team
    @basic_users = User.joins(:team_members)
                       .where(team_members: { team_id: team_id_for_high_permissions(current_user) })
                       .where(team_members: { role: 'basic' })

    @advanced_users = User.joins(:team_members)
                          .where(team_members: { team_id: team_id_for_high_permissions(current_user) })
                          .where(team_members: { role: 'advanced' })
  end

  def custodians
    @custodians = User.joins(:team_members)
                      .where(team_members: { role: 'custodian' })
  end

  def show
  end

  def edit
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
    redirect_to team_path
  end


  private

  def set_user
    @user = User.find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit(:full_name, :email, :role, :password, :password_confirmation, :current_password, team_members_attributes: [:role])
  end

end

class UsersController::InvitationsController < Devise::InvitationsController

  include ElevatedPermissionsHelper

  def invite_resource(&block)
    ## skip sending emails on invite
    super do |u|
      u.skip_invitation = true
    end

    # update team_members because the invite save only saves user
    user = User.find_by_email(resource_params[:email])
    user.team_members.create(team_id: resource_params[:team_members][:team_id],
                             role: resource_params[:team_members][:role]).save

    # send email with injected params
    user.deliver_invitation
    user
  end

end
