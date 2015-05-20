require 'pp'
require_relative '../lib/xml_to_object'

xml = File.read '../res/movies.xml'
data = (Nokogiri::XML xml).xpath "//*"
collection = XMLObject.new data[0]

puts "Collection Inspection"
puts "---"
pp collection

puts;puts

puts "Data Access"
puts "---"
pp collection.shelf
pp collection[0].title
pp collection[0][:type]
pp collection[0][:format]
