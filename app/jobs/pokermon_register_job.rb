class PokermonRegisterJob < ApplicationJob
  queue_as :default

  def perform(email, register_link)
    logger.info "开始为(#{email})注册pokermon账号..."
    virtual_user = VirtualUser.where(email: email).first
    pokermon_info = virtual_user.pokermon
    BrowserAutomation::Pokermon.register(
      email, register_link,
      name: pokermon_info.nickname,
      jp_name: pokermon_info.kana,
      birthday: virtual_user.birthdate,
      gender: virtual_user.gender,
      postal_code: pokermon_info.registry_postcode,
      street_number: pokermon_info.registry_fandi,
      password: pokermon_info.reg_password,
      mobile: pokermon_info.registry_cellphone
    )
  end
end
