require 'pp'
require_relative '../lib/object_to_xml'
require_relative '../lib/xml_to_object'

xml = File.read '../res/movies.xml'
data = (Nokogiri::XML xml).xpath "//*"
collection = XMLObject.new data[0]


puts "XML"
puts "---"
puts xml

puts;puts

puts "Collection from XML"
puts "---"
pp collection

puts;puts

puts "Collection to XML"
puts "---"
puts collection.to_xml 'collection'
