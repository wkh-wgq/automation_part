class PokermonLotteryWonMailbox < PokermonMailbox
  def process
    product_info = parse_product_info
    create_parsed_email_record do |record|
      record.data = {
        products: product_info
      }
    end
  end

  def parse_product_info
    return_block = body_decoded_text.split("【商品情報】")[1]
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

      if buffer.match?(/(\d+)個/)
        merged_lines << buffer
        buffer = ""
      end
    end

    # 用正则提取出名称和数量
    merged_lines.map do |line|
      if match = line.match(/(\d{13})[ 　]+(.+?)[ 　]+[\d,]+円[（(](\d+)個[）)]/)
        { product_code: match[1].strip, product_name: match[2].strip, quantity: match[3].to_i }
      end
    end.compact
  end
end
