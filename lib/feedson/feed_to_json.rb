
module Feedson
  class FeedToJson

    def initialize(feed_contents)
      @feed_contents = feed_contents
      @feed_document = FeedDocument.new
      @parser = Nokogiri::XML::SAX::Parser.new(@feed_document)
    end

    def as_json
      @parser.parse(@feed_contents)
      @feed_document.root
    end

  end
end
