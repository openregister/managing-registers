class RegisterUpdatesMailer < ApplicationMailer
  def register_update_request(change, user)
    @user = user
    @change = change
    @approvers = @user.team_members.first.team.users.where('team_members.role' => 'advanced' || 'custodian').reject{ |u| u == @user }.map(&:email)
    mail(from: @user.email, to: @approvers, subject: "Register update request - #{@change.register_name}")
  end

  def register_update_receipt(change, user)
    @user = user
    @change = change
    mail(to: @user.email, subject: "Register update request - #{@change.register_name}")
  end

  def register_update_rejected(change, user)
    @user = user
    @change = change
    mail(from: @user.email, to: "foo.com", subject: "Register update rejected - #{@change.change.register_name}")
  end

  def register_update_approved(change, user)
    @user = user
    @change = change
    mail(from: @user.email, to: "foo.com", subject: "Register update approved - #{@change.change.register_name}")
  end
end
