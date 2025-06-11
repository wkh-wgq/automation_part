class PokermonAutoRegisterJob < ApplicationJob
  queue_as :default

  def perform(email)
    register_link = Rails.cache.read("pokermon.email-#{email}-register_link")
    if register_link.present?
      PokermonRegisterJob.perform_now(email, register_link)
    else
      BrowserAutomation::Pokermon.send_register_email(email)
    end
  end
end
