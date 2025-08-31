class PokermonLoginCaptchaMailbox < PokermonMailbox
  def process
    email = mail.to.first || recipient
    captcha = body_decoded_text.match(/【パスコード】(\d{6})/)[1]
    Rails.cache.write("pokermon.#{email}.login_captcha", captcha, expires_in: 5.minutes)
    logger.info "===#{email}的登陆验证码：#{captcha}==="
  end
end
