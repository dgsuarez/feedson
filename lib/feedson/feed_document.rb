
module Feedson
  class FeedDocument < Nokogiri::XML::SAX::Document

    attr_reader :root

    def start_document
      @root = {}
      @current_element = @root
      @previous_element = nil
    end

    def start_element(name, attributes=[])
      @current_element[name] = {}
      @previous_element = @current_element
      @current_element = @current_element[name]
      @text_content = nil

      attributes.each do |attr_name, attr_value|
        @current_element["##{attr_name}"] = attr_value
      end
    end

    def characters(chars)
      @text_content ||= ""
      @text_content += chars
    end

    def end_element(_)
      @current_element["$t"] = @text_content if @text_content
      @current_element = @previous_element
      @text_content = nil
    end

  end
end
