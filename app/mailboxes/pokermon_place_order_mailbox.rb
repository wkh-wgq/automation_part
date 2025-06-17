class PokermonPlaceOrderMailbox < PokermonMailbox
  def process
    text = body_decoded_text
    # 提取下单时间
    place_order_time = text[/【注文日】(.+?)\n/, 1]
    # 提取订单号
    order_number = text[/【注文番号】(\d+)/, 1]
    # 提取商品信息
    items = text.scan(/(\d{13})\s+(.+?)\s+\((\d+)個\)/)
    product_info = items.map do |product_code, product_name, quantity|
      {
        product_code: product_code,
        product_name: product_name,
        quantity: quantity
      }
    end
    create_parsed_email_record do |record|
      record.type = "place_order"
      record.data = {
        place_order_time: place_order_time.strip,
        order_number: order_number,
        products: product_info
      }
    end
  end
end
