# frozen_string_literal: true

module AstroConcepts
  class AstroToc
    attr_reader :toc
    attr_reader :current_heading

    def initialize
      @toc = Heading.new('*', nil, 0, -1)
      @current_heading = toc
    end

    def process(astro_headings)
      astro_headings.each_with_index do |astro_heading, index|
        heading = Heading.new(astro_heading[:text], astro_heading[:slug], astro_heading[:depth], index)
        process_heading(heading)
      end
    end

    def root_headings
      toc.headings
    end

    def pretty
      puts JSON.pretty_generate(toc.headings.map { |h| h.to_h(include_parent: true) })
    end

    private

    def process_heading(heading)
      return add_child_heading(heading)         if heading.depth > current_heading.depth
      return add_sibling_heading(heading)       if heading.depth == current_heading.depth
      return add_upstream_heading(heading)      if heading.depth < current_heading.depth
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
      @current_heading = current_heading.parent while current_heading.valid? && heading.depth < current_heading.depth

      # There is no upstream heading to attach to, so just add a new root node
      return add_child_heading(heading) if current_heading.root?

      add_sibling_heading(heading)
    end
  end
end
