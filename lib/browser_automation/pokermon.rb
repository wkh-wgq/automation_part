module BrowserAutomation
  module Pokermon
    # 发送注册邮件
    def self.send_register_email(email)
      Pokermon::RegisterRunner.new(email).send_email
    end

    # 根据注册链接完成注册
    def self.register(email, register_link, name:, jp_name:, birthday:, gender:, postal_code:, street_number:, password:, mobile:)
      birthday = birthday.to_date if birthday.is_a?(String)
      Pokermon::RegisterRunner.new(email).register(
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

    # 发送重置密码的邮件
    def self.send_reset_password_email(email, birthday:)
      BrowserAutomation::Pokermon::ResetPasswordRunner.new(email).send_email(birthday: birthday)
    end

    # 重置密码
    def self.reset_password(email, reset_link:)
      BrowserAutomation::Pokermon::ResetPasswordRunner.new(email).reset_password(reset_link: reset_link)
    end

    # 抽奖
    def self.draw_lot(email, password:, index:)
      BrowserAutomation::Pokermon::DrawLotRunner.new(
        email: email, password: password, index: index
      ).run
    end

    # 下单
    # data: [{email:, password:, products: [{link:, quantity:}]}]
    def self.order(data)
      succ_result = []
      fail_result = []
      error_address_result = []
      data.each do |item|
        result = BrowserAutomation::Pokermon::OrderRunner.new(
          item[:email], password: item[:password], products: item[:products]
        ).run
        if result[:success]
          succ_result << { email: result[:email], order_no: result[:order_no] }
        elsif result[:error_code].present?
          error_address_result << result[:email]
        else
          fail_result << result[:email]
        end
      end
      {
        succ_result: succ_result,
        fail_result: fail_result,
        error_address_result: error_address_result
      }
    end

    def self.lottery_won_pay(emails)
      succ_result = []
      fail_result = []
      error_info_result = []
      emails.each do |email|
        result = BrowserAutomation::Pokermon::LotteryWonPayRunner.new(
          email, password: "1234Asdf."
        ).run
        if result[:success]
          succ_result << { email: result[:email], order_no: result[:order_no] }
        elsif result[:error_code].present?
          error_info_result << result[:email]
        else
          fail_result << result[:email]
        end
      end
      {
        succ_result: succ_result,
        fail_result: fail_result,
        error_info_result: error_info_result
      }
    end
  end # end module Pokermon
end # end module BrowseAutomation
