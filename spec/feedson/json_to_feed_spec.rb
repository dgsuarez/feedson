require 'spec_helper'

describe Feedson::JsonToFeed do

  def initialize_converter(feed_path)
    doc_config = {
      list_elements: %w(item)
    }
    feed = File.read(feed_path)
    feed_as_json = Feedson::FeedToJson.new(feed, doc_config: doc_config).as_json
    Feedson::JsonToFeed.new(feed_as_json, doc_config: doc_config) 
  end

  context "with very simple RSS feed" do

    subject(:converter) { initialize_converter("spec/examples/rss2sample.xml") }

    let(:xml) { converter.to_xml }

    it "returns the root element" do
      expect(xml).to match('rss version="2.0"')
    end

    it "returns children" do
      expect(xml).to match('<title>The Engine')
    end

  end

  context "with itunes feed" do

    subject(:converter) { initialize_converter("spec/examples/itunes.xml") }

    let(:xml) { converter.to_xml }

    it "sets the right namespaces" do
      expect(xml).to match("<itunes:author>")
    end

  end
end

