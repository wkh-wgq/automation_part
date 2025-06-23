module BrowserAutomation
  module Pokermon
    # 发送注册邮件
    def self.send_register_email(email)
      Pokermon::RegisterRunner.new(email: email).send_email
    end

    # 根据注册链接完成注册
    def self.register(email, register_link, name:, jp_name:, birthday:, gender:, postal_code:, street_number:, password:, mobile:)
      birthday = birthday.to_date if birthday.is_a?(String)
      Pokermon::RegisterRunner.new(email: email).register(
        register_link: register_link,
        name: name,
        jp_name: jp_name,
        birthday: birthday,
        gender: gender,
        postal_code: postal_code,
        street_number: street_number,
        password: password,
        mobile: mobile
      )
    end

    # 抽奖
    def self.draw_lot(email, password:, index:)
      BrowserAutomation::Pokermon::DrawLotRunner.new(
        email: email, password: password, index: index
      ).run
    end
  end
end
