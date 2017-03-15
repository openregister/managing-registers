class NotificationMailer < ApplicationMailer

  def register_update_notification(register, register_name, user)
    @register = register
    @register_name = register_name
    @user = user
    mail to: "data-infrastructure@digital.cabinet-office.gov.uk", from: @user, subject: "#{@register_name} new entry request"
  end
end
