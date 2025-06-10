module BrowserAutomation
  module Pokermon
    class RegisterRunner < BaseRunner
      attr_reader :email
      def initialize(email:)
        initialize_page("visitor")
        @email = email
      end

      # 发送注册链接的邮件
      def send_email
        @retry_count = 0
        click_register
        if page.url == "https://www.pokemoncenter-online.com/temporary-customer-complete/"
          logger.info "账号(#{email})发送注册邮完成"
          true
        else
          false
        end
      rescue Exception => e
        logger.error "账号(#{email})发送注册邮件失败:#{e.message}"
        false
      ensure
        close_page
      end

      # 发送注册链接
      def click_register
        page.goto(ROOT_URL)
        human_like_click("text=ログイン ／ 会員登録", wait_for_navigation: true)
        page.locator('[name="dwfrm_profile_confirmationEmail_email"]').type(email, delay: rand(100..300))
        human_like_click("#form2Button", wait_for_navigation: true)
        human_delay(4.0, 6.0)
        human_like_click("#send-confirmation-email", wait_for_navigation: true)
        human_delay(4.0, 6.0)
      rescue Exception => e
        raise e if @retry_count >= 3
        @retry_count += 1
        retry
      end
    end # end class RegisterRunner
  end # end module Pokermon
end # end module BrowserAutomation
