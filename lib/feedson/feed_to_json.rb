
module Feedson
  class FeedToJson

    def initialize(feed_contents, doc_config: {})
      @feed_contents = feed_contents
      doc_config = initialize_doc_config(doc_config)
      @feed_document = FeedSaxDocument.new(doc_config)
      @parser = Nokogiri::XML::SAX::Parser.new(@feed_document)
    end

    def as_json
      @parser.parse(@feed_contents)
      @feed_document.root
    end

    private

    def initialize_doc_config(doc_config)
      {list_elements: [], mixed_content: []}.merge(doc_config)
    end

  end
end
