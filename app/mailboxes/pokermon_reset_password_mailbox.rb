class PokermonResetPasswordMailbox < PokermonMailbox
  def process
    text = body_decoded_text
    # 提取注册链接
    reset_password_link = text[/https:\/\/www\.pokemoncenter-online\.com\/account-set-new-password\/\?passwordResetToken=[^\s]+/]

    create_parsed_email_record do |record|
      record.type = "reset_password"
      record.data = {
        reset_password_link: reset_password_link
      }
    end
    result = BrowserAutomation::Pokermon.reset_password(recipient, reset_link: reset_password_link)
    record = ExecuteRecord.of_email(recipient).for_action("reset_password").last
    if record
      record.update(result: { reset_password: result })
    end
  end
end
