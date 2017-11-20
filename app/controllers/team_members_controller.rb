# frozen_string_literal: true

class TeamMembersController < ApplicationController
  before_action :set_team_member

  def edit
    check_permissions(:TEAM_MEMBERS_EDIT, current_user: current_user,
                                          team_id: params[:team_id].to_i, team_member_id: params[:id].to_i)

    if @team_member.role == 'custodian'
      @team_members = @team_member.team.team_members.joins(:user).where.not(users: { full_name: '' })
    end
  end

  def update
    check_permissions(:TEAM_MEMBERS_UPDATE, current_user: current_user,
                                            team_member_id: params[:id].to_i)

    if @team_member.role == 'custodian'
      if params[:new_custodian_team_member_id] == params[:id]
        flash[:notice] = 'Your custodian remains unchanged'
      else
        new_custodian = TeamMember.find(params[:new_custodian_team_member_id])

        @team_member.role = 'advanced'
        new_custodian.role = 'custodian'

        @team_member.save
        new_custodian.save

        flash[:notice] = 'The custodian has been changed'
      end
      redirect_to team_path(@team_member.team_id)
    elsif @team_member.update(role: params[:team_member][:role])
      flash[:notice] = 'Your update has been successful'
      redirect_to team_path(@team_member.team_id)
    else
      flash[:notice] = 'Your update has failed'
      render :edit
    end
  end

  def destroy
    check_permissions(:TEAM_MEMBERS_DESTROY, current_user: current_user,
                                             team_id: params[:team_id].to_i, team_member_id: params[:id].to_i)

    @team_member.destroy
    flash[:notice] = "Successfully removed #{@team_member.user.full_name} from team"
    redirect_to team_path(@team_member.team_id)
  end

private

  def set_team_member
    @team_member = TeamMember.find(params[:id])
  end
end
