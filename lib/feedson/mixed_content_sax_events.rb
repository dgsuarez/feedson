module Feedson
  class MixedContentSaxEvents

    attr_reader :text

    def initialize(*)
      reset
    end

    def start_element(*)

    end

    def end_element(*)

    end

    def characters(chars)
      @text += chars
    end

    def reset
      @text = ""
    end

  end
end
