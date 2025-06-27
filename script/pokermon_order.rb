require_relative '../config/environment'
require 'csv'

def setup_logger(output = STDOUT)
  logger = ActiveSupport::Logger.new(output)
  logger.level = Logger::INFO
  logger.formatter = proc do |severity, datetime, _, msg|
    "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity} - #{msg}\n"
  end
  logger
end

Rails.logger = setup_logger

csv_path = ARGV[0]
unless csv_path && File.exist?(csv_path)
  puts "csv文件路径不存在!"
  exit
end
header = CSV.open(csv_path, 'r', headers: true).first.headers
if !header.include?('email')
  puts 'csv文件缺少头信息!'
  exit
end
header.delete('email')
if header.size % 2 != 0
  puts "csv文件头信息错误!"
  exit
end
product_size = header.size / 2
data = []
CSV.foreach(csv_path, headers: true) do |row|
  products = []
  begin
    product_size.times do |i|
      break if row["link_#{i + 1}"].blank?
      products << {
        link: row["link_#{i + 1}"],
        quantity: row["quantity_#{i + 1}"].to_i
      }
    end
  rescue Exception => _e
    puts "#{row['email']}的商品数据有误！"
    exit
  end
  data << {
    email: row['email'],
    password: "1234qwer.",
    products: products
  }
end

BrowserAutomation::Pokermon.order(data)
