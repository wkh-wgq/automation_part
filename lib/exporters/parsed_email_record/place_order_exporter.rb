module Exporters
  module ParsedEmailRecord
    class PlaceOrderExporter < BaseExporter
      def generate_csv_data
        CSV.generate(headers: true) do |csv|
          csv << %w[邮箱 订单号 商品条码 商品名称 数量 单价 运费 手续费 总价 地址]
          records.each do |r|
            data = r.data
            data["products"].each do |product|
              csv << [
                r.email,
                data["order_number"],
                product["product_code"],
                product["product_name"],
                product["quantity"],
                product["price"],
                data["shipping_fee"],
                data["handling_fee"],
                data["total_payment"],
                data["address"]
              ]
            end
          end
        end
      end
    end
  end
end
