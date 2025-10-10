class PokermonPlaceOrderMailbox < PokermonMailbox
  def process
    # 提取下单时间
    place_order_time = text[/【注文日】(.+?)\n/, 1]
    # 提取订单号
    order_number = text[/【注文番号】(\d+)/, 1]

    total_payment = text[/【支払合計】([\d,]+)円/, 1]

    shipping_fee = text[/【送料】([\d,]+)円/, 1]

    handling_fee = text[/【手数料】([\d,]+)円/, 1]

    address = text[/【お届け先】([\s\S]+?)【お届け予定日】/, 1]

    # 提取商品信息
    product_info = parse_product_info
    create_parsed_email_record do |record|
      record.data = {
        place_order_time: place_order_time,
        order_number: order_number,
        total_payment: total_payment&.gsub(",", "").to_f,
        shipping_fee: shipping_fee&.gsub(",", "").to_f,
        handling_fee: handling_fee&.gsub(",", "").to_f,
        address: address,
        products: product_info
      }
    end
  end


  def parse_product_info
    return_block = text.split("【商品情報】")[1]
    return [] unless return_block

    # 提取到下一个空行或明显段落结束
    return_block = return_block.split(/\n{2,}/)[0]

    # 分割并清理每行
    lines = return_block.lines.map(&:strip).reject(&:empty?)

    # 处理跨行组合：将换行打断的商品名和数量拼接
    merged_lines = []
    buffer = ""

    lines.each do |line|
      buffer += " " unless buffer.empty?
      buffer += line

      if buffer.match?(/(\d+)円/)
        merged_lines << buffer
        buffer = ""
      end
    end

    # 用正则提取出名称和数量
    merged_lines.map do |line|
      if match = line.match(/(\d{13})\s+(.+?)\s+\((\d+)個\)\s+小計\s+([\d,]+)円/)
        { product_code: match[1].strip, product_name: match[2].strip, quantity: match[3].to_i, price: match[4]&.gsub(",", "").to_f }
      end
    end.compact
  end
end
