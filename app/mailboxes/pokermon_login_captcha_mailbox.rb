class PokermonLoginCaptchaMailbox < PokermonMailbox
  def process
    captcha = body_decoded_text.match(/【パスコード】(\d{6})/)[1]
    Rails.cache.write("pokermon.#{recipient}.login_captcha", captcha, expires_in: 5.minutes)
    logger.info "===#{recipient}的登陆验证码：#{captcha}==="
  end
end
