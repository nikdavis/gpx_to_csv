#gpx to csv

require 'csv'

filename_wo_ext = "dodge_park"

f = File.open(filename_wo_ext + ".gpx", "r")
gpx = f.collect do |line|
  line
end
f.close

puts "GPX file is #{gpx.length} lines."
gpx = gpx.join
time = gpx.scan(/<time>(.+?)<\/time>/m).flatten
lat = gpx.scan(/lat=\"(.+?)\"/m).flatten
lon = gpx.scan(/lon=\"(.+?)\"/m).flatten

coords = time.zip(lat, lon)

unless time.length == lat.length && lat.length == lon.length
  raise "We screwed up, incongruent data!"
end

puts "We have #{coords.length} data points, making csv."

CSV.open(filename_wo_ext + ".csv", "wb") do |csv|
  csv << ["Timestamp", "Lat" , "Lon"]
  coords.each do |coord|
    csv << coord
  end
end
