require 'spec_helper'

describe Feedson::FeedToJson do

  context "with an RSS feed" do

    let(:feed) { File.read("spec/examples/rss2sample.xml") }

    let(:doc_config) do
      {
        list_elements: %w(item)
      }
    end

    subject(:converter) { Feedson::FeedToJson.new(feed, doc_config: doc_config) }

    let(:doc) { converter.as_json }

    it "returns `rss` as its root element" do
      root = doc.keys.first

      expect(root).to eq("rss")
    end

    it "returns the tags for the element with `#`" do
      version = doc["rss"]["#version"]

      expect(version).to eq("2.0")
    end

    it "returns the text content for a tag `$t`" do
      description = doc["rss"]["channel"]["description"]

      expect(description["$t"]).to match(/to Space/)
    end

    it "has a list of items" do
      p doc["rss"]["channel"]["item"]
      items = doc["rss"]["channel"]["item"]

      expect(items.length).to eq(4)
    end

  end

end
