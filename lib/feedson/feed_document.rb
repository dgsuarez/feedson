
module Feedson
  class FeedDocument < Nokogiri::XML::SAX::Document

    attr_reader :root

    def initialize(doc_config)
      @doc_config = doc_config
    end

    def start_document
      @root = {}
      @element_history = [@root]
    end

    def start_element(name, attributes=[])
      @current_element = {}
      if @doc_config[:list_elements].include?(name)
        parent_element[name] ||= []
        parent_element[name].push(@current_element)
      else
        parent_element[name] = @current_element
      end

      attributes.each do |attr_name, attr_value|
        @current_element["##{attr_name}"] = attr_value
      end
      @element_history.push(@current_element)
    end

    def characters(chars)
      @current_element["$t"] ||= ""
      @current_element["$t"] += chars
    end

    def end_element(name)
      @last_pop = @element_history.pop
    end

    private

    def parent_element
      @element_history.last
    end

  end
end
