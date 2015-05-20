class String
  def to_xml(indent = 0)
    self
  end
end

class Fixnum
  def to_xml(indent = 0)
    self.to_s
  end
end

class Double
  def to_xml(indent = 0)
    self.to_s
  end
end

class Hash
  def to_xml(indent = 0)
    xml = ""

    self.keys.each do |key|

      if self[key].is_a?(Hash)
        xml += " " * indent + "<#{key}>"
        xml += "\n"
        xml += self[key].to_xml(indent + 2)
        xml += " " * indent
        xml += "</#{key}>\n"
      elsif self[key].is_a?(Array)
        xml += " " * indent + "<#{key}>"
        xml += "\n"
        xml += self[key].to_xml('value', indent + 2)
        xml += " " * indent
        xml += "</#{key}>\n"
      elsif [String, Fixnum, Double].any? { |klass| self[key].is_a? klass }
        xml += " " * indent + "<#{key}>"
        xml += self[key].to_xml(indent + 2)
        xml += "</#{key}>\n"
      else
        xml += self[key].to_xml(key, indent)
      end
    end

    xml
  end
end

class Array
  def to_xml(base, indent = 0)
    xml = ""

    self.each do |value|

      if base.length == 0 && value.instance_variables.include?(:@__name)
        object_name = value.instance_variable_get('@__name')
      else
        object_name = 'value'
      end

      xml += " " * indent + "<#{base}>" if base.length > 0
      if value.is_a?(Hash)
        xml += "\n"
        xml += value.to_xml(indent + 2)
        xml += " " * indent
      elsif value.is_a?(Array)
        xml += "\n"
        xml += value.to_xml object_name, indent + 2
        xml += " " * indent
      elsif [String, Fixnum, Double].any? { |klass| value.is_a? klass }
        xml += value.to_xml indent + 2
      else
        xml += "\n"
        xml += value.to_xml object_name, indent
      end
      xml += " " * indent + "</#{base}>\n" if base.length > 0
    end

    xml
  end
end


class XMLVisitor
  def self.visit(object, base, attributes, indent)
    xml = " " * indent + "<#{base}"
    object.instance_variables.each do |var|
      key = var.to_s.sub '@', ''
      value = object.instance_variable_get(var)

      xml += " #{key}=\"#{value.to_s}\"" if attributes.include? key.to_sym
    end
    xml += ">\n"

    indent += 2

    count = 0
    object.instance_variables.each do |var|
      key = var.to_s.sub '@', ''
      value = object.instance_variable_get(var)

      next if key.start_with?('_') && key != '__children'
      next if attributes.include? key.to_sym

      children = (key == '__children') ? true : false
      count += 1

      if [String, Fixnum, Double].any? { |klass| value.is_a? klass }
        xml += " " * indent + "<#{key}>" unless children
        xml += value.to_xml indent + 2
        xml += "</#{key}>\n" unless children
      elsif value.is_a? Hash
        xml += " " * indent + "<#{key}>\n" unless children
        xml += value.to_xml indent 
        xml += " " * indent + "</#{key}>\n" unless children
      elsif value.is_a? Array
        xml += " " * indent + "<#{key}>\n" unless children
        xml += value.to_xml '', indent
        xml += " " * indent + "</#{key}>\n" unless children
      else
        if children
          xml += value.to_xml '', indent if value.class.method_defined? :to_xml
        else
          xml += value.to_xml key, indent if value.class.method_defined? :to_xml
        end
      end
    end

    if count > 0
      xml += " " * (indent - 2) + "</#{base}>\n"
    else
      xml[0..-3] + "/>\n"
    end

    xml.gsub /^$\n/, ''
  end
end
