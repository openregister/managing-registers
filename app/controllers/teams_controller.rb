class TeamsController < ApplicationController

  include ElevatedPermissionsHelper

  def index; end

  def show
    team_id = params[:id]

    @basic_users = User.joins(:team_members)
                       .where(team_members: { team_id: team_id, role: 'basic' })
                       .where.not(invitation_accepted_at: nil)

    @advanced_users = User.joins(:team_members)
                          .where(team_members: { team_id: team_id,
                                                 role: 'advanced' })
                          .where.not(invitation_accepted_at: nil)

    @pending_users = User.joins(:team_members)
                         .where(invitation_accepted_at: nil)
                         .where(team_members: { team_id: team_id })

    @team = Team.find(team_id)
  end

end