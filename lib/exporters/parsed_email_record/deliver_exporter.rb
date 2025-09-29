module Exporters
  module ParsedEmailRecord
    class DeliverExporter < BaseExporter
      def generate_csv_data
        CSV.generate(headers: true) do |csv|
          csv << [ "邮箱", "发送时间", "订单号", "物流单号", "下单时间", "商品条码", "商品名称", "数量" ]
          records.each do |r|
            r.data["products"].each do |product|
              csv << [
                r.email,
                r.sent_at,
                r.data["order_number"],
                r.data["delivery_order_number"],
                r.data["place_order_time"],
                product["product_code"],
                product["product_name"],
                product["quantity"]
              ]
            end
          end
        end
      end
    end
  end
end
