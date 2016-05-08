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

  end

end
