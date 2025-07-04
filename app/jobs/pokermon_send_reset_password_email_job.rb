class PokermonSendResetPasswordEmailJob < ApplicationJob
  queue_as :default

  def perform(email, birthday)
    result = BrowserAutomation::Pokermon.send_reset_password_email(email, birthday: birthday)
    ExecuteRecord.create!(email: email, action: "reset_password", params: { birthday: birthday }, result: { send_email: result })
  end
end
