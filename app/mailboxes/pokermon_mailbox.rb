class PokermonMailbox < ApplicationMailbox
  def body_decoded_text
    return @decoded_text if @decoded_text
    @decoded_text = mail.body.decoded.gsub(/\\x([0-9a-fA-F]{2})/) { |m| $1.hex.chr }.force_encoding("UTF-8")
    @decoded_text.encode("UTF-8", invalid: :replace, undef: :replace)
  end

  def recipient
    @recipient ||= body_decoded_text[/收件人:\s*([^\s\r\n<>]+)/, 1]
  end

  def sent_at
    body_decoded_text[/发送时间[:：]\s*(\d{4}年\d{1,2}月\d{1,2}日\s*\d{1,2}:\d{2})/, 1]
  end

  def create_parsed_email_record(&block)
    record = ParsedEmailRecord.new(
      inbound_email_id: inbound_email.id,
      email: recipient,
      sent_at: sent_at.strip,
    )
    block.call(record)
    record.save!
  end
end
