require 'mysql'

connection = Mysql.new('localhost', 'root', '', 'ekatte')

result = connection.query('select * from test')
result.each_hash do |h|
	puts h
end

#puts result.methods.sort
	
connection.close
