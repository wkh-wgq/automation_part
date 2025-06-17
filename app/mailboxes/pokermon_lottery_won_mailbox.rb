class PokermonLotteryWonMailbox < PokermonMailbox
  def process
    text = body_decoded_text
    # 提取商品信息
    items = text.scan(/(\d{13})[ 　]+(.+?)[ 　]+[\d,]+円[（(](\d+)個[）)]/)
    product_info = items.map do |product_code, product_name, quantity|
      {
        product_code: product_code,
        product_name: product_name,
        quantity: quantity
      }
    end

    create_parsed_email_record do |record|
      record.type = "lottery_won"
      record.data = {
        products: product_info
      }
    end
  end
end
