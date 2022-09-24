module AstroConcepts
  class Heading
    attr_reader :depth
    attr_reader :sequence
    attr_reader :text
    
    attr_accessor :parent
    attr_accessor :headings

    def initialize(depth, sequence, text)
      @depth = depth
      @sequence = sequence
      @text = text
      @parent = nil
      @headings = nil
    end

    def add_heading(heading)
      heading.parent = self
      @headings = [] if @headings.nil?
      @headings << heading
    end

    # def parent_name
    #   parent&.text || 'NULL'
    # end

    # def parent_up
    #   result = []
    #   p = self
    #   while p != nil
    #     result << p.parent_name
    #     p = p.parent
    #   end

    #   # reverse sort
    #   result.compact.reverse.join(' > ')
    # end

    # def debug(label = 'xxx')
    #   puts "- #{label} ------------------------------------------------------------"
    #   puts "depth : #{depth}"
    #   puts "sequence : #{sequence}"
    #   puts "text  : #{text}"
    #   puts "parent: #{parent_up}"
    #   puts "child count: #{headings ? headings.count : 0}"
    #   puts "headings: #{headings.map(&:text).join(', ')}" if headings
    # end

    def to_h
      result = {
        depth: depth,
        sequence: sequence,
        text: text,
        parent: parent_name,
      }

      result[:headings] = headings.map(&:to_h) if headings
        
      result
    end
  end
end