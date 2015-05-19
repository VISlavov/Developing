MULTIPLIER = 1000 * 1000

def generate_data
	max  = rand(1..50) * MULTIPLIER
	
	data = "z" * max
	data += "\n"
	data += max.to_s

	data
end

def delay
	delay = rand(0.1..1)
	sleep( delay )

	puts delay
end

request_method = ARGV[0]

puts "Script executed for #{request_method} request"
puts generate_data

delay()
