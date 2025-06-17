class PokermonReturnOrderMailbox < PokermonMailbox
  def process
    text = body_decoded_text
    # 提取下单时间
    place_order_time = text[/■ご注文日時：([0-9:\-\s]+)/, 1]
    # 提取商品信息
    items = text.scan(/^(.+?)　数量(\d+)点/)
    product_info = items.map do |product_name, quantity|
      {
        product_name: product_name,
        quantity: quantity
      }
    end
    create_parsed_email_record do |record|
      record.type = "return_order"
      record.data = {
        place_order_time: place_order_time.strip,
        products: product_info
      }
    end
  end
end
