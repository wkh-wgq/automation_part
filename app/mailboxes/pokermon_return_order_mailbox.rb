class PokermonReturnOrderMailbox < PokermonMailbox
  def process
    text = body_decoded_text
    # 提取下单时间
    place_order_time = text[/■ご注文日時：([0-9:\-\s]+)/, 1]
    # 提取商品信息
    product_info = parse_product_info
    create_parsed_email_record do |record|
      record.type = "return_order"
      record.data = {
        place_order_time: place_order_time.strip,
        products: product_info
      }
    end
  end

  def parse_product_info
    # 提取“■ご返品商品：”后面的部分
    return_block = body_decoded_text.split("■ご返品商品：")[1]
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

      if buffer.match?(/数量\s*\d+点/)
        merged_lines << buffer
        buffer = ""
      end
    end

    # 用正则提取出名称和数量
    merged_lines.map do |line|
      if match = line.match(/(.+?)\s*数量\s*(\d+)点/)
        { product_name: match[1].strip, quantity: match[2].to_i }
      end
    end.compact
  end
end
