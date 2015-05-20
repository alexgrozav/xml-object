require_relative '../lib/object_to_xml'

class DataObject
  attr_reader :data

  def initialize
    @data = {
      data1: {
        data11: [1,2,3],
        data12: [4,5,6],
        data13: [7,8,9]
      },
      data2: [1,2,3,4,5,6],
      data3: SubDataObject.new
    }

    @other = {
      hello: 'Hello',
      world: 'Earth'
    }

    @test = SubDataObject.new


    @attribute1 = "hello"
    @attribute2 = "world"
  end

  def to_xml(base = '', indent = 0)
    attributes = ['attribute1', 'attribute2']
    XMLVisitor.visit(self, base, attributes, indent)
  end
end

class SubDataObject < DataObject
  def initialize
    @subdata = {
      who: 'I am subdata',
      where: 'Inside of data'
    }

    @point = SubSubDataObject.new

    @myattr = 'sub attr'
  end

  def to_xml(base = '', indent = 0)
    attributes = [:myattr]
    XMLVisitor.visit(self, base, attributes, indent)
  end
end

class SubSubDataObject < DataObject
  def initialize
    @x = 100
    @y = 200
  end

  def to_xml(base = '', indent = 0)
    attributes = [:x, :y]
    XMLVisitor.visit(self, base, attributes, indent)
  end
end


hash = {
  key1: "value 1",
  key2: "value 2",
  key3: {
    keky31: [1, [1,2,3,4,5], 3, 4],
    keky32: "value 3 2",
    keky33: "value 3 3"
  }
}

array = [1, 2, 3, 4, 5, 6, 7]

data = DataObject.new

object_array = [SubSubDataObject.new, SubSubDataObject.new, SubSubDataObject.new]

puts hash.to_xml

puts;puts

puts array.to_xml 'value'

puts;puts

puts object_array.to_xml 'object'

puts;puts

puts data.to_xml 'object'
