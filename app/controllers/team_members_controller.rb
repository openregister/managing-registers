class TeamMembersController < ApplicationController

  def edit
    @team_member = TeamMember.find(params[:id])

    if @team_member.role == 'custodian'
      @team_members = @team_member.team.team_members.joins(:user).where.not(users: {full_name: ''} )
    end
  end

  def update

    team_member = TeamMember.find(params[:id])

    if team_member.role == 'custodian'
      if params[:new_custodian_team_member_id] == params[:id]
        flash[:notice] = 'Your custodian remains unchanged'
      else
        new_custodian = TeamMember.find(params[:new_custodian_team_member_id])

        team_member.role = 'advanced'
        new_custodian.role = 'custodian'

        team_member.save
        new_custodian.save

        flash[:notice] = 'The custodian has been changed'
      end
      redirect_to team_path(team_member.team_id)
    else
      if team_member.update(role: params[:team_member][:role])
        flash[:notice] = 'Your update has been successful'
        redirect_to team_path(team_member.team_id)
      else
        flash[:notice] = 'Your update has failed'
        render :edit
      end
    end

  end

end
