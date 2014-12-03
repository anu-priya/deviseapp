require 'geocoder'	   

namespace :geotask  do
  desc "update city table with latitude and longitude"
  task :location => :environment do
    @city = City.all
	p "Total Count Of city = #{@city.length}"
	a = 1
    @city.each do |c|
      coord = Geocoder.coordinates(c.city_name)
      sleep(5)
      if !coord.nil?
        c.latitude = coord[0]
        c.longitude = coord[1]
        c.save
      end
	  p "Last run City Name: #{c.city_name}"
	   p "Total runned : #{a}"
	  a+=1
     
    end
  end
end