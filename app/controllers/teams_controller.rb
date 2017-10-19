class TeamsController < ApplicationController

  include ElevatedPermissionsHelper
  before_action :set_team, only: [:show, :edit, :update]

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
  end

  def edit; end

  def update
    updated_registers_keys ||= []
    params[:team][:registers_attributes]
      .reject{ |index, register| register[:_destroy] }
      .each_pair { |index, register| updated_registers_keys.push(register[:key])}

    @team.update_registers(updated_registers_keys).save

    flash[:notice] = 'Registers updated successfully'
    redirect_to team_path
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

end