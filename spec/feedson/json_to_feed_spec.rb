require 'spec_helper'

describe Feedson::JsonToFeed do

  context "with very simple RSS feed" do

    let(:feed) { File.read("spec/examples/rss2sample.xml") }

    let(:doc_config) do
      {
        list_elements: %w(item)
      }
    end

    let(:feed_as_json) do
      Feedson::FeedToJson.new(feed, doc_config: doc_config).as_json
    end

    subject(:converter) { Feedson::JsonToFeed.new(feed_as_json, doc_config: doc_config) }

    let(:xml) { converter.to_xml }

    it "returns the root element" do
      expect(xml).to match('rss version="2.0"')
    end

    it "returns children" do
      expect(xml).to match('<title>The Engine')
    end

  end
end

