require 'nokogiri'
class XmlParser
  XML_FILE = 'orders.xml'
  RECEIPT_FILE = 'order_receipt.txt'

  def initialize
    @xml_data = File.read(XML_FILE)
    @extracted_data = Nokogiri::XML(@xml_data)
  end

  def self.call
    new.parse
  end

  def parse
    products = @extracted_data.xpath('//product')
    customer_name = @extracted_data.xpath('//customer_name').text
    order_id = @extracted_data.xpath('//order_id').text

    File.open(RECEIPT_FILE, 'w') do |file|
      title_padding = (40 - "Receipt".length) / 2

      file.puts(" " * title_padding + "Order Receipt")
      file.puts
      file.puts("Customer Name: #{customer_name}")
      file.puts("Order ID: #{order_id}")
      file.puts("---------------------------------")
      products.each do |product|
        product_id = product.xpath('product_id').text
        product_name = product.xpath('product_name').text
        product_quantity = product.xpath('quantity').text
        product_price = product.xpath('unit_price').text
        file.puts("Prduct ID: #{product_id}")
        file.puts("Prduct Name: #{product_name}")
        file.puts("Prduct Quantity: #{product_quantity}")
        file.puts("Prduct Price: #{product_price}")
        file.puts("---------------------------------")
      end
  
    end
  rescue StandardError => e
    puts "Error: #{e.message}"
  end
end

XmlParser.call


