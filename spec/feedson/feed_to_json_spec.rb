require 'spec_helper'

describe Feedson::FeedToJson do

  def initialize_converter(file_name, doc_config)
    feed_path = File.join("spec/examples", file_name)
    feed = File.read(feed_path)
    Feedson::FeedToJson.new(feed, doc_config: doc_config)
  end

  let(:rss_doc_config) do
    {
      list_elements: %w(item)
    }
  end

  let(:atom_doc_config) do
    {
      list_elements: %w(entry),
      mixed_content: %w(content)
    }
  end

  context "with very simple RSS feed" do

    subject(:converter) do
      initialize_converter("rss2sample.xml", rss_doc_config)
    end

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
      items = doc["rss"]["channel"]["item"]

      expect(items.length).to eq(4)
    end

    it "parses each item" do
      items = doc["rss"]["channel"]["item"]

      expect(items.last["title"]["$t"]).to match(/Astronauts/)
    end

    it "doesn't add whitespace only text elements" do
      text_node = doc["rss"]["$t"]

      expect(text_node).to be_nil
    end

  end

  context "with an itunes podcast feed" do

    subject(:converter) do
      initialize_converter("itunes.xml", rss_doc_config)
    end

    let(:doc) { converter.as_json }

    it "doesn't have problems with namespaces" do
      itunes_subtitle = doc["rss"]["channel"]["itunes:subtitle"]["$t"]

      expect(itunes_subtitle).to match(/A show/)
    end
  end

  context "with mixed atom & html content" do

    subject(:converter) do
      initialize_converter("nondefaultnamespace-xhtml.atom", atom_doc_config)
    end

    let(:doc) { converter.as_json }

    it "collapses mixed content elements into a text one" do
      entry_content = doc["feed"]["entry"].first["content"]["$t"]

      expect(entry_content).to match(/XML namespace conformance tests/)
    end

  end

end
