require 'spec_helper'

describe Feedson::FeedToJson do

  def initialize_converter(file_name, doc_config)
    feed_path = File.join("spec/examples", file_name)
    feed = File.read(feed_path)
    Feedson::FeedToJson.new(feed, doc_config: doc_config)
  end

  let(:rss_doc_config) { Feedson::Formats::RssConfig.new }

  let(:atom_doc_config) { Feedson::Formats::AtomConfig.new }

  let(:itunes_rss_doc_config) { Feedson::Formats::ItunesRssConfig.new }

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
      initialize_converter("itunes.xml", itunes_rss_doc_config)
    end

    let(:doc) { converter.as_json }

    it "doesn't have problems with namespaces" do
      itunes_subtitle = doc["rss"]["channel"]["itunes:subtitle"]["$t"]

      expect(itunes_subtitle).to match(/A show/)
    end

    it "has multiple categories" do
      itunes_categories = doc["rss"]["channel"]["itunes:category"]

      expect(itunes_categories.length).to eq(3)
    end

    it "has a list of items" do
      items = doc["rss"]["channel"]["item"]

      expect(items.length).to eq(3)
    end
  end

  context "with mixed atom & html content" do

    subject(:converter) do
      initialize_converter("nondefaultnamespace-xhtml.atom", atom_doc_config)
    end

    let(:doc) { converter.as_json }

    it "collapses mixed content elements into a single text one" do
      entry_content = doc["feed"]["entry"].first["content"]

      expect(entry_content.keys).to eq(["#type", "$t"])
    end

    it "returns text with tags for the mixed content elements" do
      entry_content = doc["feed"]["entry"].first["content"]["$t"]

      expect(entry_content).to match(/an <h:abb/)
    end

    it "keeps the attributes for the children tags" do
      entry_content = doc["feed"]["entry"].first["content"]["$t"]

      expect(entry_content).to match(/<h:abbr title="/)

    end

  end

  context "with CDATA fields" do
    subject(:converter) do
      initialize_converter("tender_love.xml", rss_doc_config)
    end

    let(:doc) { converter.as_json }

    it "inserts CDATA content as a text node" do
      item_description = doc["rss"]["channel"]["item"].first["description"]["$t"]

      expect(item_description).to match(/^<!\[CDATA\[Oops.*?\]\]>$/m)
    end

  end

end
