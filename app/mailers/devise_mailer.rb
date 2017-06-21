class DeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  def reset_password_instructions(record, token, opts={})
    set_template(Rails.application.secrets.notify_password_reset_template)

    set_personalisation(
      user_full_name: record.full_name,
      edit_password_url: edit_password_url(record, reset_password_token: token)
    )

    mail(to: record.email)
  end

  def password_change(record, opts={})
    set_template(Rails.application.secrets.notify_password_change_template)

    set_personalisation(
      user_full_name: record.full_name
    )

    mail(to: record.email)
  end

  def invitation_instructions(record, token, opts={})
    case record.team_members.last.role

    when 'admin'
      set_template(Rails.application.secrets.notify_admin_invite_template)
      set_personalisation(
        current_user_full_name: User.find(record.invited_by_id).full_name,
        invite_url: accept_invitation_url(record, invitation_token: token)
      )

    when 'custodian'
      set_template(Rails.application.secrets.notify_custodian_invite_template)
      set_standard_personalisations(record, token)

    when 'advanced'
      set_template(Rails.application.secrets.notify_advanced_invite_template)
      set_standard_personalisations(record, token)

    when 'basic'
      set_template(Rails.application.secrets.notify_basic_invite_template)
      set_standard_personalisations(record, token)
    end

    mail(to: record.email)
  end

  def set_standard_personalisations(record, token)
    set_personalisation(
      current_user_full_name: User.find(record.invited_by_id).full_name,
      invite_url: accept_invitation_url(record, invitation_token: token),
      registers: record.team_members.last.team.registers
    )
  end
end
