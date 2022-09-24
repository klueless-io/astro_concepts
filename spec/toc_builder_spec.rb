# frozen_string_literal: true
require 'pry'

RSpec.describe RailsAppGenerator::TocBuilder do
  let(:astroHeadings) {
    [
      { depth: 3, text: 'H3 (before H1)', children: [] },
      { depth: 1, text: 'H1', children: [] },
      { depth: 2, text: 'H2 A', children: [] },
      { depth: 2, text: 'H2 B', children: [] },
      { depth: 2, text: 'H2 C', children: [] },
      { depth: 3, text: 'H3 C-A', children: [] },
      { depth: 3, text: 'H3 C-B', children: [] },
      { depth: 4, text: 'H4 C-B-1', children: [] },
      { depth: 1, text: 'H1 (Again)', children: [] },
      { depth: 3, text: 'H3 C-B', children: [] },
      { depth: 2, text: 'Sub heading D', children: [] },
      { depth: 3, text: 'H3 D-A', children: [] },
      { depth: 3, text: 'H3 D-B' },
      { depth: 1, text: 'H1 (One last Time)', children: [] },
    ]
  }

  it { 
    builder = TocBuilder.new(astroHeadings)
    builder.build
    puts JSON.pretty_generate(builder.toc)
    File.write('spec/lib/rails_app_generator/a1.json', JSON.pretty_generate(builder.toc))
    builder.recent_heading_by_depth
  }
end