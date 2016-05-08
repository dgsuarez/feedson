
module Feedson
  class FeedDocument < Nokogiri::XML::SAX::Document

    attr_reader :root

    def initialize
      @root = {}
      @current_element = @root
    end

    def start_element(name, attributes=[])
      @current_element[name] = {}
      @current_element = @current_element[name]

      attributes.each do |attr_name, attr_value|
        @current_element["##{attr_name}"] = attr_value
      end
    end

  end
end
