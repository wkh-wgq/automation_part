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
    end
  end
end
