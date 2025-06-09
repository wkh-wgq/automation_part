module BrowserAutomation
  module Pokermon
    def self.send_register_email(email)
      result = Pokermon::RegisterRunner.new(email: email).send_email
      unless result
        raise "发送注册邮件失败！"
      end
    end
  end
end
