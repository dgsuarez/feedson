module Feedson
  class MixedContentSaxEvents

    attr_reader :text

    def initialize(*)
      reset
    end

    def start_element(name, attrs)
      attrs_as_text = attrs.map { |key, value| %Q(#{key}="#{value}") }.join(" ")
      @text += "<#{name} #{attrs_as_text}>"
    end

    def end_element(name)
      @text += "</#{name}>"
    end

    def characters(chars)
      @text += chars
    end

    def reset
      @text = ""
    end

  end
end
