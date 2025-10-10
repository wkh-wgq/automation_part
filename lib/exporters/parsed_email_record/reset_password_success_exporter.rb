module Exporters
  module ParsedEmailRecord
    class ResetPasswordSuccessExporter < BaseExporter
      def generate_csv_data
        CSV.generate(headers: true) do |csv|
          csv << [ "邮箱", "发送时间" ]
          records.each do |r|
            csv << [
              r.email,
              r.sent_at
            ]
          end
        end
      end
    end
  end
end
