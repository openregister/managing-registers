class NotificationMailer < GovukNotifyRails::Mailer
  def register_update_notification(register, register_name, user)
    set_template('bf3dc10d-3146-4de3-bf5c-6b0705dd705d')

    set_personalisation(
      new_entry: register,
      user: user,
      register: register_name
    )

    mail(to: "data-infrastructure@digital.cabinet-office.gov.uk")
  end
end
