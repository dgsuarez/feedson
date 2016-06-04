
module Feedson
  class JsonToFeed

    def initialize(feed_as_json)
      @feed_as_json = feed_as_json
    end

    def to_xml
      builder.to_xml
    end

    private

    def builder
      Nokogiri::XML::Builder.new do |xml|
        root_name, root_content = @feed_as_json.first
        add_node(xml, root_name, root_content)
      end
    end

    def add_node(xml, tag_name, content)
      if content.is_a?(Array)
        content.each { |tag_content| add_node(xml, tag_name, tag_content) }
      else
        add_single_node(xml, tag_name, content)
      end
    end

    def add_single_node(xml, tag_name, tag_content)
      method_name = "#{tag_name}_".to_sym
      attributes = get_attributes(tag_content)

      xml.send(method_name, attributes) do
        add_tag_content(xml, tag_content)
      end
    end

    def add_tag_content(xml, tag_content)
      tag_content.each do |key, contents|
        if cdata?(key, contents)
          inner_contents = extract_cdata(contents)
          xml.cdata(inner_contents)
        elsif text?(key)
          xml.text(contents)
        elsif !attribute?(key)
          add_node(xml, key, contents)
        end
      end
    end

    def extract_cdata(contents)
      cdata_extrator = /<!\[CDATA\[(.*)\]\]/m
      match_data = contents.match(cdata_extrator)
      match_data && match_data[1]
    end

    def get_attributes(tag_content)
      attrs = tag_content.select { |key, _| attribute?(key)}.map do |name, value|
        [name.slice(1 .. -1), value]
      end
      Hash[attrs]
    end

    def attribute?(key)
      key =~ /^#/
    end

    def cdata?(key, contents)
      text?(key) && contents =~ /\b*<!\[CDATA/
    end

    def text?(key)
      key == "$t"
    end

  end
end
