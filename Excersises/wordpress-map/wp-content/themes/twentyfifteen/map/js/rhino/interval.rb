while(true) do
	`crontab -l | grep '^#' | cut -f 6- -d ' ' | while read CMD; do eval $CMD; done`
	puts ' --- update --- '

	interval = ARGV[0]
	third_of_time = (interval / 3).ceil
	time = 0

	while(time != ARGV[0]) do
		time += third_of_time
		sleep(third_of_time)
		
		puts "#{interval - time} seconds remaining"
	end
end
