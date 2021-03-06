require 'spec_helper'

describe Feedson::JsonToFeed do

  def initialize_converter(file_name)
    feed_path = File.join("spec/examples", file_name)
    feed = File.read(feed_path)
    feed_as_json = Feedson.parse(feed_contents: feed, format: :rss)

    Feedson::JsonToFeed.new(feed_as_json)
  end

  context "with very simple RSS feed" do

    subject(:converter) { initialize_converter("rss2sample.xml") }

    let(:xml) { converter.to_xml }

    it "returns the root element" do
      expect(xml).to match('rss version="2.0"')
    end

    it "returns children" do
      expect(xml).to match('<title>The Engine')
    end

  end

  context "with itunes feed" do

    subject(:converter) { initialize_converter("itunes.xml") }

    let(:xml) { converter.to_xml }

    it "sets the right namespaces" do
      expect(xml).to match("<itunes:author>")
    end

  end

  context "with CDATA fields" do
    subject(:converter) { initialize_converter("tender_love.xml") }

    let(:xml) { converter.to_xml }

    it "doesn't escape the CDATAs" do
      expect(xml).to match(/<!\[CDATA/)
    end

    it "adds the full content for multiline cdatas" do
      expect(xml).to match(/<p>Conditional functionality added to methods with no weird "alias method chain/)
    end


  end
end

