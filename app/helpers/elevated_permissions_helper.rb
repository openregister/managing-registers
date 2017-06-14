module ElevatedPermissionsHelper

  # find team_id which I have elevated permissions
  # given i'm advanced or custodian user
  # @param [user] user
  # @return [int] team_id
  # NOTE: We still dont know what multiple high permission world looks like yet
  def team_id_for_high_permissions(user)
    if !user.team_members.where(role: 'custodian').empty?
      user.team_members.where(role: 'custodian').first.team_id
    else
      user.team_members.where(role: 'advanced').first.team_id
    end
  end

end