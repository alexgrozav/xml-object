# XML-Object Converter

Convert any XML file into a Ruby object instance or convert any ruby object
into XML.


## Class Method
To start using the converter, simply add the following method into your
class and let the converter do its magic.

The __base__ is the root element name.

```ruby
class DataClass
  def to_xml(base = '', indent = 0)
    attributes = [:attr1, :attr2]
    XMLVisitor.visit(self, base, attributes, indent)
  end
end
```

To convert an object to XML code run:
```ruby
data = DataClass.new
xml = data.to_xml 'object'
```

To convert XML code to an object run:
```ruby
xml = File.read '../res/movies.xml'
data = (Nokogiri::XML xml).xpath "//*"
collection = XMLObject.new data[0]

# Accessing attributes
pp collection.shelf
pp collection[0].title
pp collection[0][:type]
pp collection[0][:format]
```
