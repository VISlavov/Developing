require './warehouse.rb'

warehouse = Warehouse.new()

routes = warehouse.get_routes()
stock_type_count = warehouse.get_stock_type_count()

puts "#{stock_type_count} #{routes}"
