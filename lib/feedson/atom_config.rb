module Feedson
  class AtomConfig

    def list_element?(element_name)
      %w(entry).include?(element_name)
    end

    def mixed_element?(element_name)
      %w(content).include?(element_name)
    end

  end
end
