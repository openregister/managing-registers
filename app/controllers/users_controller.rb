class UsersController < ApplicationController

  include ElevatedPermissionsHelper
  before_action :set_user

  def admin
    @users = User.joins(:team_members)
                 .where(team_members: { role: 'admin' })

    authorize! :admin, @users
  end

  def team
    params[:team_id].present? ? team_id = params[:team_id] : team_id = team_id_for_high_permissions(current_user)

    @basic_users = User.joins(:team_members)
                       .where(team_members: { team_id: team_id })
                       .where(team_members: { role: 'basic' })
                       .where.not(invitation_accepted_at: nil)

    @advanced_users = User.joins(:team_members)
                          .where(team_members: { team_id: team_id })
                          .where(team_members: { role: 'advanced' })
                          .where.not(invitation_accepted_at: nil)

    @pending_users = User.joins(:team_members)
                         .where(team_members: { team_id: team_id })
                         .where(invitation_accepted_at: nil)
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

    user = User.find_by_email(resource_params[:email])

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

    # send email with injected params
    user.deliver_invitation
    user

  end

end
