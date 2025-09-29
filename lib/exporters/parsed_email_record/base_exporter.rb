module Exporters
  module ParsedEmailRecord
    class BaseExporter
      attr_reader :records
      def initialize(records)
        @records = records
      end

      def generate_csv_data
        raise "暂不支持的导出类型"
      end
    end
  end
end
