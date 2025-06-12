class PokermonRegisterMailbox < ApplicationMailbox
  # 接收宝可梦注册邮件，并提取其中的注册链接进行注册
  def process
    decoded_text = mail.body.decoded.gsub(/\\x([0-9a-fA-F]{2})/) { |m| $1.hex.chr }.force_encoding("UTF-8")
    text = decoded_text.encode("UTF-8", invalid: :replace, undef: :replace)
    return logger.warn "不是注册邮件，忽略处理！" unless text.include? "new-customer"
    match = text.match(/▼URL\s*\n\s*(https:\/\/www\.pokemoncenter-online\.com\/new-customer\/\?token=[^\s]+)/i)
    return logger.warn "邮件中没有找到注册链接！" unless match
    register_link = match[1].strip
    email = decoded_text[/收件人:\s*([^\s\r\n<>]+)/, 1]
    return logger.warn "邮件中没有找到邮箱地址！" unless email
    logger.info "收到(#{email})的pokermon注册邮件，注册链接:#{register_link}"
    virtual_user = VirtualUser.where(email: email).first
    return logger.warn "邮箱(#{email})未查询到虚拟用户！" unless virtual_user
    pokermon_info = virtual_user.pokermon
    return logger.warn "邮箱(#{email})未查询到宝可梦注册信息" unless pokermon_info
    Rails.cache.write("pokermon.email-#{email}-register_link", register_link, expires_in: 20.minutes)
    logger.info "异步注册宝可梦账号(#{email})..."
    PokermonRegisterJob.perform_later(email, register_link)
  end
end
