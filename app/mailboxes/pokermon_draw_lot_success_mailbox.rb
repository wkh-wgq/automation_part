class PokermonDrawLotSuccessMailbox < PokermonMailbox
  def process
    product_info = parse_product_info
    create_parsed_email_record do |record|
      record.data = {
        products: product_info
      }
    end
  end

  def parse_product_info
    # 提取商品信息行
    product_line = body_decoded_text[/【商品情報】\r\n\s*(.+)/, 1]
    if product_line =~ /(\d{13})\u3000(.+?)\u3000[\d,]+円（(\d+)個）/
      product_code = $1
      product_name = $2
      quantity = $3.to_i
      {
        product_code: product_code,
        product_name: product_name,
        quantity: quantity
      }
    end
  end
end
