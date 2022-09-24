# frozen_string_literal: true

module AstroConcepts
  class Heading
    attr_reader :depth
    attr_reader :sequence
    attr_reader :text
    attr_reader :opts

    attr_accessor :parent
    attr_accessor :headings

    def initialize(depth, sequence, text, opts = {})
      @depth = depth
      @sequence = sequence
      @text = text
      @opts = opts
      @parent = nil
      @headings = nil
    end

    def add_heading(heading)
      heading.parent = self
      @headings = [] if @headings.nil?
      @headings << heading
    end

    def to_h
      result = {
        depth: depth,
        sequence: sequence,
        text: text
      }.merge(opts)

      result[:headings] = headings.map(&:to_h) if headings

      result
    end

    def debug(label = nil)
      puts "- #{label} ------------------------------------------------------------" if label
      puts "depth       : #{depth}"
      puts "sequence    : #{sequence}"
      puts "text        : #{text}"
      puts "opts        : #{opts}"
      puts "headings    : #{headings.map(&:text).join(', ')}" if headings
    end
  end
end
