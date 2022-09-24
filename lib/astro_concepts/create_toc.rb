# frozen_string_literal: true

module AstroConcepts
  class CreateToc
    attr_reader :headings
    attr_reader :hierarchies
    attr_reader :hierarchy_root
    attr_reader :current_heading

    def initialize(headings)
      @headings = headings.map.with_index do |heading, index|
        AstroConcepts::Heading.new(heading.depth, index, heading.text)
      end
      @hierarchies = []
      @hierarchy_root = nil
      @current_hierarchy = nil
    end

    # Process the raw headings and create a list of hierarchies
    def process
      headings.each do |heading|
        process_heading(heading)
      end
    end

    def to_h
      hierarchies.map(&:to_h)
    end

    def debug
      hierarchies.each do |hierarchy|
        puts JSON.pretty_generate(hierarchy.to_h)
      end
    end

    private

    # rubocop:disable Metrics/AbcSize
    def process_heading(heading)
      return new_hierarchy(heading) if hierarchy_root.nil?
      return add_child_heading(heading)        if heading.depth > current_heading.depth
      return add_sibling_heading(heading)      if heading.depth == current_heading.depth

      # When an up-stream heading is encountered, you have to navigate up to the existing
      # hierarchy or create a new hierarchy out side of the current hierarchy
      return new_hierarchy(heading)            if heading.depth <= hierarchy_root.depth
      return add_upstream_heading(heading)     if heading.depth < current_heading.depth
    end
    # rubocop:enable Metrics/AbcSize

    def new_hierarchy(heading)
      hierarchies << heading

      @hierarchy_root = heading
      @current_heading = heading
    end

    def add_child_heading(heading)
      current_heading.add_heading(heading)
      @current_heading = heading
    end

    def add_sibling_heading(heading)
      @current_heading = current_heading.parent
      add_child_heading(heading)
    end

    def add_upstream_heading(heading)
      @current_heading = current_heading.parent while !current_heading.nil? && heading.depth < current_heading.depth
      add_sibling_heading(heading)
    end
  end
end
