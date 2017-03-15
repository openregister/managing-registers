class NotificationMailer < ApplicationMailer

  def register_update_notification(register, register_name)
    @register = register
    @register_name = register_name
    mail to: "data-infrastructure@digital.cabinet-office.gov.uk", from: "tony.wooron@cabinet-office.gov.uk", subject: "#{@register_name} change request"
  end
end
