
module Feedson
  class FeedToJson

    def initialize(feed_contents, doc_config: nil)
      @feed_contents = feed_contents
      @feed_document = FeedSaxDocument.new(doc_config)
      @parser = Nokogiri::XML::SAX::Parser.new(@feed_document)
    end

    def as_json
      @parser.parse(@feed_contents)
      @feed_document.root
    end

  end
end
