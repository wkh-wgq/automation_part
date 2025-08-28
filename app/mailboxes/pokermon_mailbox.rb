class PokermonMailbox < ApplicationMailbox
  def body_decoded_text
    @body_decoded_text ||= begin
      raw_body = mail.body.decoded.gsub(/\\x([0-9a-fA-F]{2})/) { |m| $1.hex.chr }
      # 解析原始编码
      detected = CharDet.detect(raw_body)
      original_encoding = detected["encoding"] || "UTF-8"
      raw_body.force_encoding(original_encoding).encode("UTF-8", invalid: :replace, undef: :replace)
    end
  end

  def recipient
    @recipient ||= begin
      body_decoded_text[/^(?:To:|收件人:)\s*(?:.*?<)?([A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,})>?/, 1]
    end
  end

  def sent_at
    body_decoded_text[/发送时间[:：]\s*(\d{4}年\d{1,2}月\d{1,2}日\s*\d{1,2}:\d{2})/, 1] || body_decoded_text[/Sent[:：]\s*(\d{4}年\d{1,2}月\d{1,2}日\s*\d{1,2}:\d{2})/, 1]
  end

  def create_parsed_email_record(&block)
    type = self.class.name.gsub("Pokermon", "").gsub("Mailbox", "").underscore
    record = ParsedEmailRecord.new(
      inbound_email_id: inbound_email.id,
      email: recipient,
      sent_at: sent_at.strip,
      type: type
    )
    block.call(record) if block_given?
    record.save!
  end
end
