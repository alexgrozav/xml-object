require 'nokogiri'

class XMLObject
  def initialize(data)
    @__attributes = []
    @__name = data.name

    add_attributes data.attributes if data.attributes
    add_children data.children if data.children.length > 0
  end

  def add_attributes(attributes)
    attributes.each do |key, attribute|
      name = attribute.name
      value = attribute.value

      instance_variable_set("@#{name}", value)
      @__attributes << name.to_sym

      self.class.send :attr_accessor, "#{name}"
    end
  end

  def add_children(children)
    children.select do |child|
      child.text.strip != ''
    end.each do |child|
      text = child.children.select do |child|
        child.text.strip != ''
      end[0].is_a? Nokogiri::XML::Text

      if text
        @__children ||= {}
        @__children[child.name.to_sym] = child.text
      else
        @__children ||= []
        @__children.push XMLObject.new child
      end
    end
  end

  def [](index)
    @__children[index]
  end

  def []=(index, value)
    @__children[index] = value
  end

  def to_xml(base = '', indent = 0)
    XMLVisitor.visit(self, base, @__attributes, indent)
  end
end
