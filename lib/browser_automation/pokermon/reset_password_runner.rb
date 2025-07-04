module BrowserAutomation
  module Pokermon
    class ResetPasswordRunner < BaseRunner
      attr_reader :email
      def initialize(email)
        initialize_page(email.split(".").first)
        @email = email
      end

      # 发送注册链接的邮件
      def send_email(birthday:)
        @birthday = birthday.to_date
        @retry_count = 0
        click_reset
        sleep 10
        if page.url == "https://www.pokemoncenter-online.com/reset-password-send/"
          logger.info "账号(#{email})发送密码重置邮件完成"
          true
        else
          logger.warn "账号(#{email})发送密码重置邮件失败"
          false
        end
      rescue Exception => e
        logger.error "账号(#{email})发送密码重置邮件报错:#{e.message}"
        false
      ensure
        close_page
      end

      # 发送注册链接
      def click_reset
        page.goto(ROOT_URL)
        human_like_click("text=ログイン ／ 会員登録", wait_for_navigation: true)

        human_like_click("a[href='/reset-password/']")
        human_delay(1.0, 3.0)
        if page.url != "https://www.pokemoncenter-online.com/reset-password/"
          raise "点击重置密码链接失败！"
        end

        human_like_click("#email")
        page.locator("#email").type(email, delay: rand(100..300))

        page.locator("[name='dwfrm_profile_customer_birthdayyear']").select_option(value: @birthday.year.to_s)
        human_delay
        page.locator("[name='dwfrm_profile_customer_birthdaymonth']").select_option(value: format("%02d", @birthday.month))
        human_delay
        page.locator("[name='dwfrm_profile_customer_birthdayday']").select_option(value: format("%02d", @birthday.day))
        human_delay

        human_like_move_to_element(page.locator("text=再発行用メールを送信する"))
        human_delay
        human_like_click("text=再発行用メールを送信する")
        human_delay(4.0, 6.0)
      rescue Exception => e
        raise e if @retry_count >= 3
        @retry_count += 1
        retry
      end

      def reset_password(reset_link:)
        page.goto reset_link

        human_like_move_to_element(page.locator("[name='dwfrm_profile_login_passwordconfirm']"))

        human_like_click("[name='dwfrm_profile_login_password']")
        human_delay(0.4, 0.8)
        page.locator("[name='dwfrm_profile_login_password']").type("1234Asdf.", delay: rand(50..150))

        human_like_click("[name='dwfrm_profile_login_passwordconfirm']")
        human_delay(0.4, 0.8)
        page.locator("[name='dwfrm_profile_login_passwordconfirm']").type("1234Asdf.", delay: rand(50..150))

        human_like_move_to_element(page.locator("text=更新する"))
        human_delay
        human_like_click("text=更新する")

        human_delay(5.0, 8.0)

        if page.url != "https://www.pokemoncenter-online.com/regist-complete/"
          raise "重置密码失败！"
        end
      rescue Exception => e
        logger.error "账号(#{email})注册失败:#{e.message}"
        logger.error e
        false
      ensure
        close_page
      end
    end # end class RegisterRunner
  end # end module Pokermon
end # end module BrowserAutomation
