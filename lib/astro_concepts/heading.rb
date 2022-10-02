# frozen_string_literal: true

module AstroConcepts
  class Heading
    attr_accessor :parent
    attr_accessor :sequence
    attr_reader :text
    attr_reader :slug
    attr_reader :depth
    attr_reader :headings

    def initialize(text, slug, depth, sequence)
      @parent = parent
      @text = text
      @slug = slug
      @depth = depth
      @sequence = sequence
      @headings = []
    end

    def add_heading(heading)
      heading.parent = self
      @headings = [] if @headings.nil?
      @headings << heading
    end

    def root?
      depth.zero?
    end

    def valid?
      depth.positive?
    end

    # rubocop:disable Metrics/AbcSize
    def to_h(include_parent: false)
      result = {}

      result[:parent_name] = parent.text if include_parent && parent
      result[:sequence] = sequence
      result[:depth] = depth
      result[:text] = text if text
      result[:slug] = slug if slug
      result[:headings] = headings.map(&:to_h) if headings.length.positive?

      result
    end
    # rubocop:enable Metrics/AbcSize
  end
end
