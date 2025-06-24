module BrowserAutomation
  module Pokermon
    class OrderRunner < BaseRunner
      attr_reader :email
      def initialize(email, password:, products:)
        @email = email
        @password = password
        @products = products
        initialize_page(email.split(".").first)
        @login_retry_count = 0
      end

      def run
        go_home_page
        %w[random_browse login shopping fill_order_no].each do |method|
          send(:execute_with_log, method)
        end
        logger.info "用户(#{email})下单完成"
        "#{email}->#{@order_no}"
      rescue Exception => _e
        logger.error "用户(#{email})下单流程异常结束"
        false
      ensure
        close_page
      end

      # def queue_up
      #   return if page.title != QUEUE_UP_TITLE
      #   logger.info "用户(#{email})开始排队"
      #   while (page.wait_for_load_state(state: "load"); page.title == QUEUE_UP_TITLE)
      #     sleep 5
      #   end
      #   # while !page.locator("#buttonConfirmRedirect").visible?
      #   #   sleep 5
      #   # end
      #   logger.info "用户(#{email})排队完成"
      #   sleep rand(4.0..8.0)
      #   # 点击进入网站按钮
      #   # page.locator("#buttonConfirmRedirect").click
      #   # logger.info "用户(#{email})进入网站"
      # end

      def login
        human_like_click("text=ログイン ／ 会員登録", wait_for_navigation: true)
        human_like_click("#login-form-email")
        # 输入帐号
        page.locator("#login-form-email").type(email, delay: rand(50..200))
        sleep(rand(0.4..0.8))
        # 点击tab键
        page.keyboard.press("Tab")
        sleep(rand(0.4..0.8))
        # 输入密码
        page.locator("#current-password").type("1234qwer.", delay: rand(50..200))
        sleep(rand(0.6..1.2))
        page.keyboard.press("Enter")
        sleep(rand(5..10))
        unless page.url == MY_URL
          raise "登陆失败！" if @login_retry_count >= 3
          @login_retry_count += 1
          login
        end
      end

      def shopping
        add_carts
        human_like_click("text=レジに進む")
        human_like_move_to_element(page.locator(".submit-shipping"))
        human_like_click(".submit-shipping")
        sleep(rand(3..5))
        human_like_move_to_element(page.locator("text=代金引換"))
        human_like_click("text=代金引換")
        human_like_move_to_element(page.locator("text=ご注文内容を確認する"))
        human_like_click("text=ご注文内容を確認する")
        sleep(rand(3..5))
        human_like_move_to_element(page.locator("text=注文を確定する").last)
        human_like_click_of_element(page.locator("text=注文を確定する").last)
      end

      def add_carts
        @products.each do |product|
          add_cart(product[:link], product[:quantity])
        end
      end

      # 加入购物车
      def add_cart(link, quantity)
        page.goto link
        human_like_move_to_element(page.locator("text=カートに入れる"))
        # human_like_click("#quantity")
        page.select_option("#quantity", value: quantity.to_s)
        human_like_click("text=カートに入れる")
        sleep(rand(2..5))
        human_like_click("text=注文手続きへ進む")
        sleep(rand(1..3))
      end

      # 回填订单号
      def fill_order_no
        sleep 10
        human_like_move_to_element(page.locator("text=トップページへ"))
        @order_no = page.locator(".numberTxt .txt").inner_text
        logger.info "用户(#{email})订单号：#{@order_no}"
      end

      def execute_with_log(method)
        logger.debug "用户(#{email})下单-(#{method})流程开始"
        send(method)
        logger.debug "用户(#{email})下单-(#{method})流程结束"
      rescue Exception => e
        logger.error "用户(#{email})下单-(#{method})流程异常：#{e.message}"
        logger.error e
        raise e
      end
    end # end class OrderRunner
  end # end module Pokermon
end # end module BrowserAutomation
