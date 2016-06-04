module Feedson
  module Formats
    class RssConfig

      def list_element?(element_name)
        %w(item category).include?(element_name)
      end

      def mixed_element?(element_name)
        %w(description).include?(element_name)
      end

    end
  end
end
