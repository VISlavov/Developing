require '~/Dropbox/what-the/Dev/Excersises/ekatte_api/db.rb'

searched_name = ARGV[0]

harvester = EkatteHarvester.new()
harvester.get_data(searched_name)
