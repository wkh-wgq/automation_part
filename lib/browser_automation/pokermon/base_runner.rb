module BrowserAutomation
  module Pokermon
    class BaseRunner < BrowserAutomation::BaseRunner
      # 排队的页面title
      QUEUE_UP_TITLE = "Queue-it"
      # 限制访问的页面title
      RESTRICTED_ACCESS_TITLE = "Restricted access"
      # 首页url
      ROOT_URL = "https://www.pokemoncenter-online.com"
      # 我的页面
      MY_URL = "https://www.pokemoncenter-online.com/mypage/"

      def go_home_page
        page.goto(ROOT_URL, waitUntil: "domcontentloaded")
      end

      # 校验网络是否被限制访问
      def validate_network
        raise "网络被限制访问！" if page.title == RESTRICTED_ACCESS_TITLE
      end

      # 清空购物车
      def clear_cart
        human_like_click('a[href="/cart/"]', wait_for_navigation: true)
        while page.locator("ul.cart-list > li a.remove-product").count > 0
          human_like_click_of_element(page.locator("ul.cart-list > li a.remove-product").first)
        end
        human_delay
      end

      # 随机浏览
      def random_browse
        # return if rand < 0.3
        block = -> do
          # 随机向下滚动
          human_like_scroll(scroll_times: (3..5), scorll_length: (300..600))
          # 向上滚动到页面顶部
          human_like_move_to_top
        end
        # block.call if rand < 0.5
        block.call
        human_like_click("text=新商品", wait_for_navigation: true)
        block.call
      end

      def queue_up
        return if page.title != QUEUE_UP_TITLE
        logger.info "开始排队"
        while (page.wait_for_load_state(state: "load"); page.title == QUEUE_UP_TITLE)
          sleep 5
        end
        # while !page.locator("#buttonConfirmRedirect").visible?
        #   sleep 5
        # end
        logger.info "排队完成"
        sleep rand(4.0..8.0)
        # 点击进入网站按钮
        # page.locator("#buttonConfirmRedirect").click
        # logger.info "用户(#{account_no})进入网站"
      end
    end
  end
end
