class PokermonResetPasswordSuccessMailbox < PokermonMailbox
  def process
    create_parsed_email_record
  end
end
