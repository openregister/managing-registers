class DeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  def reset_password_instructions(record, token, opts={})
    set_template('b19e6e3a-0690-4102-a46e-e05f10552bd9')

    set_personalisation(
      user_full_name: record.full_name,
      edit_password_url: edit_password_url(record, reset_password_token: token)
    )

    mail(to: record.email)
  end

  def password_change(record, opts={})
    set_template('7a4cd8d2-8a92-4dbd-84ed-9483ddf26dc4')

    set_personalisation(
      user_full_name: record.full_name
    )

    mail(to: record.email)
  end

  def invitation_instructions(record, token, opts={})
    case record.team_members.last.role

    when 'admin'
      set_template('cca89657-03e4-4c88-9c9b-affd4c406ce6')
      set_personalisation(
        current_user_full_name: User.find(record.invited_by_id).full_name,
        invite_url: accept_invitation_url(record, invitation_token: token)
      )

    when 'custodian'
      set_template('a59b23da-049c-49e4-b4dc-ed2ee05cb363')
      set_standard_personalisations(record, token)

    when 'advanced'
      set_template('9ada2d3b-744d-4d8e-9285-3af133d55bac')
      set_standard_personalisations(record, token)

    when 'basic'
      set_template('cda8bcc4-c814-4042-b191-ab57dcf7f7ea')
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
