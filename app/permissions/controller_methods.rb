module Permissions
  module ControllerMethods

    def check_permissions(action, check_params)
      return false unless action.present?

      case action
        when :REGISTER_INDEX
          raise PermissionError unless RegisterPolicy.view?(check_params[:current_user], check_params[:register_name])
        when :REGISTER_NEW
          raise PermissionError unless RegisterPolicy.new?(check_params[:current_user], check_params[:register_name])
        when :REGISTER_EDIT
          raise PermissionError unless RegisterPolicy.update?(check_params[:current_user], check_params[:register_name])
        when :REGISTER_CONFIRM
          raise PermissionError unless RegisterPolicy.confirm?(check_params[:current_user], check_params[:register_name])
        when :REGISTER_CREATE_PENDING_REVIEW
          raise PermissionError unless RegisterPolicy.create_pending_review?(check_params[:current_user], check_params[:register_name])
        when :REGISTER_CREATE_AND_REVIEW
          raise PermissionError unless RegisterPolicy.create_and_review?(check_params[:current_user], check_params[:register_name])
        when :TEAM_MEMBERS_EDIT
          raise PermissionError unless TeamMembersPolicy.edit?(check_params[:current_user], check_params[:team_id], check_params[:team_member_id])
        when :TEAM_MEMBERS_UPDATE
          raise PermissionError unless TeamMembersPolicy.update?(check_params[:current_user], check_params[:team_member_id])
        when :TEAM_MEMBERS_DESTROY
          raise PermissionError unless TeamMembersPolicy.destroy?(check_params[:current_user], check_params[:team_id], check_params[:team_member_id])
        when :TEAMS_INDEX
          raise PermissionError unless TeamsPolicy.index?(check_params[:current_user])
        when :TEAMS_SHOW
          raise PermissionError unless TeamsPolicy.show?(check_params[:current_user], check_params[:team_id])
        when :TEAMS_EDIT
          raise PermissionError unless TeamsPolicy.edit?(check_params[:current_user], check_params[:team_id])
        when :TEAMS_UPDATE
          raise PermissionError unless TeamsPolicy.update?(check_params[:current_user], check_params[:team_id])
        when :USERS_ADMIN
          raise PermissionError unless UserPolicy.admin?(check_params[:current_user])
        when :USERS_CUSTODIANS
          raise PermissionError unless UserPolicy.custodians?(check_params[:current_user])
        when :USERS_SHOW
          raise PermissionError unless UserPolicy.show?(check_params[:current_user],check_params[:user])
        when :USERS_NEW
          raise PermissionError unless UserPolicy.new?(check_params[:current_user], check_params[:role], check_params[:team_id])
        when :USERS_CREATE
          raise PermissionError unless UserPolicy.create?(check_params[:current_user])
        when :USERS_DESTROY
          raise PermissionError unless UserPolicy.destroy?(check_params[:current_user])
        when :CHANGE_SHOW
          raise PermissionError unless ChangePolicy.show?(check_params[:current_user], check_params[:register_name])
        when :CHANGE_EDIT
          raise PermissionError unless ChangePolicy.edit?(check_params[:current_user], check_params[:register_name])
        when :CHANGE_DESTROY
          raise PermissionError unless ChangePolicy.destroy?(check_params[:current_user], check_params[:register_name])
        when :CHANGE_UPDATE
          raise PermissionError unless ChangePolicy.update?(check_params[:current_user], check_params[:register_name])
        else
          raise PermissionError
      end
    end
  end
end