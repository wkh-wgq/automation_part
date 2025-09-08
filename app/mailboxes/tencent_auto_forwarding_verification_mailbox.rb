class TencentAutoForwardingVerificationMailbox < ApplicationMailbox
  def process
    link = text.scan(%r{https?://[^\s<>]+}).detect { |url| url.include?("/cgi-bin/attrset") }
    ParsedEmailRecord.create!(
      inbound_email_id: inbound_email.id,
      email: recipient,
      type: "tencent_auto_forwarding_verification",
      data: { link: link }
    )
  end
end
