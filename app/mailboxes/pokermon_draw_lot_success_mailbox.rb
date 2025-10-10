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
    # 允许跨行提取【商品情報】之后的整段文本（最多到下一个空行）
    product_block = text[/【商品情報】\s*([\s\S]+?)\n\n/, 1]
    # 去掉换行符，方便后续正则匹配
    product_line = product_block.gsub(/\s+/, " ")
    if product_line =~ /(\d{13})\u3000(.+?)\u3000([\d,]+)円（\d+個）/
      product_code = $1
      product_name = $2
      price = $3
      {
        product_code: product_code,
        product_name: product_name,
        price: price&.gsub(",", "").to_f
      }
    end
  end
end
