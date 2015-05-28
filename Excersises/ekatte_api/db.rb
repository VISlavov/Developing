require 'mysql'
require 'set'
require 'unicode_utils'

class EkatteHarvester

	def initialize

	end

	def print_data data
		data.each do |d|
			name = ''

			if d[1].is_a? String
				name = d[1]
			else
				d[1].each_hash do |h|
					if h["name"]	
						name += h["name"]
					end
				end
			end

			puts "#{d[0]} : #{name}"
		end

		puts 
		puts
	end

	def is_mysql_result_empty result
		is_empty = true

		result.each_hash do |h|
			if h
				is_empty = false

				break
			end
		end

		is_empty
	end

	def add_heading_zero digit
		digit = digit.to_s

		if digit.length == 1 && digit >= '0' && digit <= '9'
			digit =  '0' + digit
		end

		digit
	end
		
	def leave_only_letter_chars_and_space string
		string = string.gsub(/((?![[:word:]]| ).)/, '')

		string
	end

	def is_match_valid match_hash, searched_name
		name = match_hash["name"]

		name = name.force_encoding(Encoding::UTF_8)
		searched_name = searched_name.force_encoding(Encoding::UTF_8)

		name = leave_only_letter_chars_and_space(name)
		searched_name = leave_only_letter_chars_and_space(searched_name)

		name = UnicodeUtils.simple_downcase(name)
		searched_name = UnicodeUtils.simple_downcase(searched_name)

		if name.include? ' '
			match_name_parts = name.split(' ')
		else
			match_name_parts = [name]
		end

		if searched_name.include? ' '
			searched_name_parts = searched_name.split(' ')
		else
			searched_name_parts = [searched_name]
		end

		return (match_name_parts & searched_name_parts) != []
	end

	def find_max_duplicates(collection)
		max = 0

		collection.each do |elem|
			duplicates = collection.count(elem)
			if duplicates > max
				max = duplicates
			end
		end

		max
	end

	def	find_inaccurate_matches connection, query, searched_name 
		searched_name_parts = searched_name.split(' ')

		matches = []
		matches_hashes = []
		matches_hashes_set = Set.new()

		searched_name_parts.each do |part|
			matches << connection.query(query % [part])
		end

		matches.each do |match|
			match.each_hash do |h|
				if is_match_valid(h, searched_name)
					matches_hashes << h	
				end
			end
		end

		max_duplicates = find_max_duplicates(matches_hashes)

		matches_hashes.each do |h|
			if matches_hashes.count(h) == max_duplicates
				matches_hashes_set.add(h)
			end
		end

		matches_hashes_set
	end

	def find_matches connection, query, searched_name
		matches_hashes = Set.new
		
		matches = connection.query(query % [searched_name])
		matches.each_hash do |h|
			if is_match_valid(h, searched_name)
				matches_hashes << h
			end
		end

		inacurate_matches_hashes = find_inaccurate_matches(connection, query, searched_name)
		matches_hashes.merge(inacurate_matches_hashes)

		matches_hashes.to_a
	end

	def print_results_for_regular_location connection, searched_name
		matches = find_matches(connection, "select * from ek_atte where instr(name,'%s') > 0", searched_name)
		
		matches.each do |h|
			data = {}
			
			puts "#{h['name']}:"
			province = h['oblast']
			township = h['obshtina']
			townhall = h['kmetstvo']
			tsb = h['tsb']
			tsb = add_heading_zero(tsb)
			type_of_occupation = h['t_v_m']

			province_name = connection.query("select name from ek_obl where oblast = '#{province}'")
			region = connection.query("select region from ek_obl where oblast = '#{province}'")

			region.each_hash do |h|
				region = h["region"]
			end

			region_name = connection.query("select name from ek_reg2 where region = '#{region}'")
			township_name = connection.query("select name from ek_obst where obstina = '#{township}'")
			townhall_name = connection.query("select name from ek_kmet where kmetstvo = '#{townhall}'")
			tsb_name = connection.query("select name from ek_tsb where tsb = '#{tsb}'")

			data["province"] = province_name
			data["region"] = region_name
			data["township"] = township_name
			data["townhall"] = townhall_name
			data["tsb"] = tsb_name
			data["type_of_occupation"] = type_of_occupation

			print_data(data)
		end
	end

	def print_results_for_resorts connection, searched_name
		matches = find_matches(connection, "select * from ek_sobr where instr(name,'%s') > 0", searched_name)

		matches.each do |h|
			data = {}
			
			puts "#{h['name']}:"
			info = h['area1']

			info = info.gsub(/\(.+\)/, '')
			info = info.split(', ')

			info.each do |info_part|
				info_part = info_part.split(' ')
				data[info_part[0]] = info_part[1]	
			end

			print_data(data)
		end
	end

	def format_searched_name searched_name
		searched_name = searched_name.gsub('_', ' ')
		searched_name = searched_name.gsub('!', '"')

		searched_name
	end

	def get_data searched_name
		searched_name = format_searched_name(searched_name)
		connection = Mysql.new('localhost', 'root', '', 'ekatte')
		
		print_results_for_regular_location(connection, searched_name)
		print_results_for_resorts(connection, searched_name)

		connection.close
	end

end
