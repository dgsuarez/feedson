require 'nokogiri'

require "feedson/version"

require 'feedson/json_to_feed'
require 'feedson/feed_to_json'
require 'feedson/feed_sax_document'

require 'feedson/sax_events/regular'
require 'feedson/sax_events/mixed_content'

require 'feedson/formats/itunes_rss_config'
require 'feedson/formats/atom_config'
require 'feedson/formats/rss_config'

module Feedson
  def self.dump(json_data: nil)
    converter = Feedson::JsonToFeed.new(json_data)
    converter.to_xml
  end

  def self.parse(feed_contents: nil, format: :rss)
    converter = Feedson::FeedToJson.new(feed_contents, doc_config: doc_config(format))
    converter.as_json
  end

  private

  def self.doc_config(format)
    case format
    when :itunes then Formats::ItunesRssConfig.new
    when :atom then Formats::AtomConfig.new
    else Formats::RssConfig.new
    end
  end

end
