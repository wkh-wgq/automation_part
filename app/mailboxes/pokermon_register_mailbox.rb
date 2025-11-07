class PokermonRegisterMailbox < PokermonMailbox
  # 接收宝可梦注册邮件，并提取其中的注册链接进行注册
  def process
    # 提取注册链接
    register_link = text[/▼URL\s*\n\s*(https:\/\/www\.pokemoncenter-online\.com\/new-customer\/\?token=[^\s]+)/i, 1]
    Rails.cache.write("pokemon.#{recipient}.register_link", register_link, expires_in: 20.minutes)
    logger.info "===#{recipient}的注册链接:#{register_link}"
  end
end
