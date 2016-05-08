
module Feedson
  class FeedSaxDocument < Nokogiri::XML::SAX::Document

    attr_reader :root

    def initialize(doc_config)
      @doc_config = doc_config
    end

    def start_document
      @root = {}
      @element_history = [@root]
    end

    def start_element(name, attributes=[])
      initialize_current_element(name)
      add_attributes(attributes)
    end

    def characters(chars)
      if chars =~ /[^\s]/
        @current_element["$t"] ||= ""
        @current_element["$t"] += chars
      end
    end

    def end_element(name)
      @element_history.pop
    end

    private

    def initialize_current_element(name)
      @current_element = {}
      if list_element?(name)
        parent_element[name] ||= []
        parent_element[name].push(@current_element)
      else
        parent_element[name] = @current_element
      end
      @element_history.push(@current_element)
    end

    def add_attributes(attributes)
      attributes.each do |attr_name, attr_value|
        @current_element["##{attr_name}"] = attr_value
      end
    end

    def parent_element
      @element_history.last
    end

    def list_element?(name)
      @doc_config[:list_elements].include?(name)
    end

  end
end
