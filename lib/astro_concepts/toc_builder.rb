module RailsAppGenerator
  class TocBuilder
    attr_reader :root
    attr_reader :raw_headings
    attr_reader :depth_last
    attr_reader :last_headings
    attr_reader :root_headings

    def initialize(raw_headings)
      @root = []
      @raw_headings = raw_headings
      @depth_last = [nil] * 6
      @root_headings = []
      @last_headings = {}
    end

    def build
      raw_headings.each_with_index do |raw_heading, i|
        heading = RailsAppGenerator::Heading.new(raw_heading[:depth], i, raw_heading[:text])

        puts "processing ##{i} - depth: #{heading.depth}, text: #{heading.text}"

        if heading.depth == 1
          root << heading
        else
          heading.debug
          recent_heading_by_depth
          # parent = find_parent(heading)
          parent = find_closest_parent(heading)
          heading.parent = parent
          parent.headings ||= []
          parent.headings << heading
        end

        depth_last[heading.depth-1] = heading
      end

      build_root
    end

    def build_root
    end

    # Find the nearest heading with a depth less then current heading
    #   - This routine will handle the situation where H1..H6 do not
    #     follow standard hierarchy.
    # eg. 
    # heading       sequence     depth    root
    #     H3        0             3       true
    #   H2          1             2       true
    # H1            2             1       true
    #     H3        3             3       false
    #   H2          4             2       false
    #       H4      5             4       false
    #   H2          6             2       false
    #     H3        7             3       false
    # H1            8             1       true
    def find_closest_parent(heading)
      depth = heading.depth-2
      return nil if depth < 0
      depth_last[..depth].compact.max_by(&:sequence)
    end

    def find_parent(heading)
      depth = heading.depth-1
      (depth).downto(1) do |i|
        return depth_last[i-1] if depth_last[i-1]
      end
      nil
    end

    def toc
      { 
        headings: root.map(&:to_h)
      }
    end

    def recent_heading_by_depth
      depth_last.each_with_index do |item, i|
        puts "depth_last[#{i}]: #{item.nil? ? 'NOT SET' : item.text}"
      end
    end
  end
end