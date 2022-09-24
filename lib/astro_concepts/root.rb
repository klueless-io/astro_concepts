module AstroConcepts
  # A Web Page can have multiple root heading elements
  #
  # It is not a good practice to do this, but you have no control over how
  # someone would place their headings in a page
  class Root
    attr_reader :roots

    def initialize
      @roots = []
    end

    def single_root?
      
    end

    def multiple_root?
    end
  end
end