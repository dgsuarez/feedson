
module Feedson
  class FeedSaxDocument < Nokogiri::XML::SAX::Document

    def initialize(doc_config)
      @doc_config = doc_config
      @regular_events = SaxEvents::Regular.new(doc_config)
      @mixed_content_events = SaxEvents::MixedContent.new(doc_config)
    end

    def start_document
      regular_events.reset
      mixed_content_events.reset
      @mixed_elements = []
    end

    def start_element(name, attributes=[])
      current_events.start_element(name, attributes)
      mixed_elements.push(name) if doc_config.mixed_element?(name)
    end

    def cdata_block(cdata_content)
      current_events.characters("<![CDATA[#{cdata_content}]]>")
    end

    def characters(chars)
      current_events.characters(chars)
    end

    def end_element(name)
      if on_closing_mixed?(name)
        regular_events.characters(mixed_content_events.text)
        mixed_content_events.reset
      end

      mixed_elements.pop if doc_config.mixed_element?(name)

      current_events.end_element(name)
    end

    def root
      current_events.root
    end

    private

    attr_reader :regular_events, :mixed_content_events, :mixed_elements, :doc_config

    def current_events
      if mixed_elements.empty?
        regular_events
      else
        mixed_content_events
      end
    end

    def on_closing_mixed?(name)
      doc_config.mixed_element?(name) && mixed_elements.size == 1
    end

  end
end
