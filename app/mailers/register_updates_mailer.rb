class RegisterUpdatesMailer < GovukNotifyRails::Mailer
  def register_update_notification(change, user)
    set_template('cd3c0bbc-9dca-4a93-927b-55bca56943a8')

    set_personalisation(
      entry: change.payload,
      requester_name: user.email,
      register_name: change.register_name,
      request_date: Date.today
    )

    @approvers = user.team_members.first.team.users.where('team_members.role' => 'advanced' || 'custodian').reject{ |u| u == user }.map(&:email)

    mail(to: @approvers)
  end

  def register_update_receipt(change, user)
    set_template('9ae96146-f4b6-43dd-9aa6-9f59bd027759')

    set_personalisation(
      entry: change.payload,
      register_name: change.register_name,
      request_date: Date.today
    )

    mail(to: user.email)
  end

  def register_update_rejected(change, user)
    set_template('84d7a953-98bb-4213-bf28-26437844d245')

    set_personalisation(
      entry: change.payload,
      register_name: change.register_name,
      request_date: change.created_at.strftime("%d %B %Y"),
      reviewer_name: user.full_name,
      reason_declined: change.status.comment
    )

    mail(from: user.email)
  end

  def register_update_approved(change, user)
    set_template('ec1d8ada-5d8c-4e25-b1e8-23a81d6e4ef7')

    set_personalisation(
      entry: change.payload,
      register_name: change.register_name,
      request_date: change.created_at.strftime("%d %B %Y"),
      approval_date: Date.today,
      approver_name: user.full_name,
      register_url: "https://#{change.register_name}.register.gov.uk",
    )

    mail(to: change.user.email)
  end
end
