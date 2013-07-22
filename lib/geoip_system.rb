 require 'rubygems'
 require 'geoip'
 require 'ostruct'
module GeoipSystem

 class Location < OpenStruct
end
 
 class GeoSystem
   class << self
     DB = GeoIP.new(RAILS_ROOT + '/lib/GeoLiteCity.dat')
     retResult = ""
     def lookup(ip)
       location = []
       if result = DB.country(ip)
         #location = Location.new
         #
         # {:country_code=>"FR", :country_code3=>"FRA", :country_name=>"France", :latitude=>46.0, :longitude=>2.0}
         #
         cnt = 0
         result.each do |key, val|
           #location.send "#{cnt}=", key
           location.insert(cnt,key)
           cnt = cnt + 1
         end
       end
       location
     end
   end
 end
end