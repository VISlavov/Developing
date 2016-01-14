class Column

	attr_accessor :name, :type, :constraints

	def initialize name = '', type = '', constraints = ''
		@name = format_name name
		@type = format_type type
		@constraints = constraints
		@relation
	end

	def format_name name
		name = name.tr(", \n", '')

		name
	end

	def format_type type
		type = type.tr(", \n", '')

		if (type.include? 'string') || (type.include? 'text')
			type = 'varchar'
		end

		if (type.include? 'varchar') && !(type =~ /.+\(.+\)/)
			type += '(15)'
		end

		if type.include? 'integer'
			type = 'int'
		end

		if type.include? 'double'
			type = 'float'
		end

		if type.include? 'currency'
			type = 'decimal'
		end

		type
	end

	def generate_dummy_value number_base = 1
		data = ""
		
		if type ==  "int" || type == "float" || (type.include? "decimal")
			data = number_base
		elsif type.include? "varchar"
			data = "'" + name + number_base.to_s + "'"
		elsif type.include? "boolean"
			data = "true"
		elsif type == "date"
			data =
				"'" + 
				"1" +
				number_base.to_s +
				number_base.to_s + 
				number_base.to_s + 
				"-" + 
				"0" + 
				number_base.to_s + 
				"-" +
				"0" + 
				number_base.to_s +
				"'"
		end
		
		data.to_s
	end

end
