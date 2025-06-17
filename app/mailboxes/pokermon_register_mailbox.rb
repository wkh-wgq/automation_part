class PokermonRegisterMailbox < PokermonMailbox
  # 接收宝可梦注册邮件，并提取其中的注册链接进行注册
  def process
    logger.info "#{inbound_email.class}"
    text = body_decoded_text
    # 提取注册链接
    register_link = text[/▼URL\s*\n\s*(https:\/\/www\.pokemoncenter-online\.com\/new-customer\/\?token=[^\s]+)/i, 1]
    create_parsed_email_record do |record|
      record.type = "register"
      record.data = {
        register_link: register_link
      }
    end
    virtual_user = VirtualUser.where(email: recipient).first
    return logger.warn "邮箱(#{recipient})未查询到虚拟用户！" unless virtual_user
    pokermon_info = virtual_user.pokermon
    return logger.warn "邮箱(#{recipient})未查询到宝可梦注册信息" unless pokermon_info
    Rails.cache.write("pokermon.email-#{recipient}-register_link", register_link, expires_in: 20.minutes)
    logger.info "异步注册宝可梦账号(#{recipient})..."
    PokermonRegisterJob.perform_later(recipient, register_link)
  end
end
