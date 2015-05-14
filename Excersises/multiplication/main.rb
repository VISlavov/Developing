position = ARGV[0].to_i

sequence = ''
current_number = 1
power = 2
digit = 0

while sequence.length < position do
	current_element = (current_number ** power).to_s
	sequence += current_element
	current_number += 1
end

position -= 1

digit = sequence[position]

puts digit
