require 'spec_helper'

describe Feedson::FeedToJson do

  context "with an RSS feed" do

    let(:feed) { File.read("spec/examples/rss2sample.xml") }

    subject(:converter) { Feedson::FeedToJson.new(feed) }

    it "returns `rss` as its root element" do
      root = converter.as_json.keys.first

      expect(root).to eq("rss")
    end

    it "returns the tags for the element with `#`" do
      version = converter.as_json["rss"]["#version"]

      expect(version).to eq("2.0")
    end

    it "returns the text content for a tag `$t`" do
      doc = converter.as_json
      description = doc["rss"]["channel"]["description"]

      expect(description["$t"]).to match(/to Space/)
    end

  end

end
