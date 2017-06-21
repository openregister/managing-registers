class TeamsController < ApplicationController

  include ElevatedPermissionsHelper

  def index; end

  def show
    team_id = params[:id]

    @custodian_team_member = TeamMember.where(team_id: team_id, role: 'custodian').last

    @advanced_team_members = TeamMember.joins(:user)
                                       .where(team_id: team_id, role: 'advanced')
                                       .where.not(users: {invitation_accepted_at: nil})

    @basic_team_members = TeamMember.joins(:user)
                                    .where(team_members: { team_id: team_id, role: 'basic' })
                                    .where.not(users: {invitation_accepted_at: nil})

    @pending_team_members = TeamMember.joins(:user)
                                      .where(team_id: team_id)
                                      .where(users: {invitation_accepted_at: nil})


    @team = Team.find(team_id)
  end

end