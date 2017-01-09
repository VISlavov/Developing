path = ARGV[0]
argument = ARGV[1]
directories_back = ARGV[2]

if directories_back != ''
	directories_back = directories_back.to_i
	path = ("../" * directories_back) + path
end

result = `ruby #{path} #{argument}`

puts result
