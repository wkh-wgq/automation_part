class PokermonLoginCaptchaMailbox < PokermonMailbox
  def process
    captcha = text.match(/【パスコード】(\d{6})/)[1]
    Rails.cache.write("pokemon.#{recipient}.login_captcha", captcha, expires_in: 5.minutes)
    logger.info "===#{recipient}的登陆验证码：#{captcha}==="
  end
end
