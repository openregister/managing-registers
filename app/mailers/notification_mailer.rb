class NotificationMailer < GovukNotifyRails::Mailer
  def register_update_notification(register, register_name, current_user)
    set_template('bf3dc10d-3146-4de3-bf5c-6b0705dd705d')

    set_personalisation(
      new_entry: register,
      user: current_user.email,
      register: register_name
    )

    mail(to: "registerteam@digital.cabinet-office.gov.uk")
  end

  def register_update_confirmation(register_name, current_user)
    set_template('afb0d054-d872-447e-a551-d3103e49c65f')

    set_personalisation(
      user: current_user.email,
      register: register_name
    )

    mail(to: current_user.email)

  end
end
