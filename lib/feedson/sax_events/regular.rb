module Feedson
  module SaxEvents
    class Regular

      attr_reader :root

      def initialize(doc_config)
        @doc_config = doc_config
        reset
      end

      def start_element(name, attributes)
        @current_element = {}
        if doc_config.list_element?(name)
          parent_element[name] ||= []
          parent_element[name].push(current_element)
        else
          parent_element[name] = current_element
        end
        element_history.push(current_element)
        add_attributes(attributes)
      end

      def characters(chars)
        if chars =~ /[^\s]/
          current_element["$t"] = chars
        end
      end

      def end_element(name)
        element_history.pop
      end

      def reset
        @root = {}
        @element_history = [@root]
      end

      private

      attr_reader :current_element, :element_history, :doc_config

      def add_attributes(attributes)
        attributes.each do |attr_name, attr_value|
          current_element["##{attr_name}"] = attr_value
        end
      end

      def parent_element
        element_history.last
      end

    end
  end
end
