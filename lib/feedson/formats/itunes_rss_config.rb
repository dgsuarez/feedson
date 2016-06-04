module Feedson
  module Formats
    class ItunesRssConfig

      def initialize
        @rss_config = RssConfig.new
      end

      def list_element?(element_name)
        %w(itunes:category).include?(element_name) ||
          rss_config.list_element?(element_name)
      end

      def mixed_element?(element_name)
        %w(content:encoded itunes:summary).include?(element_name) ||
          rss_config.mixed_element?(element_name)
      end

      private

      attr_reader :rss_config

    end
  end
end
