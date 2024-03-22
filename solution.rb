require "http"
require "json"

puts "==========================================================="
puts "==========================================================="
puts "=================  Where are you today?  =================="
puts "==========================================================="
puts "==========================================================="

user_input = gets.chomp.strip.split(" ")
address = ""

for part in user_input
  address += ("%20" + part.strip)
end

address = address[3, address.length]
gmaps_key = ENV.fetch("GMAPS_KEY")
url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{gmaps_key}"

response = HTTP.get(url)

if response.status.to_i != 200
  puts "Address not found, try again!"

else
  tmp = address.split("%20").join(" ")
  puts "Searching weather for "+tmp
end

parsed_response = JSON.parse response
indexed =  parsed_response["results"][0]["geometry"]["location"]
lat = indexed["lat"]
long = indexed["lng"]

pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{lat},#{long}"

response = HTTP.get(url)
if response.status.to_i != 200
  puts "Coordinates are incorrect, latitude #{lat} and longitude #{long}"

else
  puts "Searching weather at coordinates latitude #{lat} and longitude #{long}"
end

parsed = JSON.parse response

temp = parsed["currently"]["temperature"]

puts "It is currently #{temp}°F."

summary = parsed["minutely"]["summary"]

puts "The next hour's forecast is #{summary.downcase}"

precipitation_probability = parsed["hourly"]["data"][1]["precipProbability"]


if precipitation_probability > 0.10
    puts "There is a #{(precipitation_probability * 100).round}% chance of precipitation. An umbrella might be nice!"
else
  puts "You probably won't need an umbrella. Enjoy the day!"
end
