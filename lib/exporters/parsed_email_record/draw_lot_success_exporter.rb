module Exporters
  module ParsedEmailRecord
    class DrawLotSuccessExporter < BaseExporter
      def generate_csv_data
        CSV.generate(headers: true) do |csv|
          csv << [ "邮箱", "发送时间", "商品条码", "商品名称", "单价" ]
          records.each do |r|
            r.data["products"].each do |product|
              csv << [
                r.email,
                r.sent_at,
                product["product_code"],
                product["product_name"],
                product["price"]
              ]
            end
          end
        end
      end
    end
  end
end
