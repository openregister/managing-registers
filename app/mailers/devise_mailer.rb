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

end