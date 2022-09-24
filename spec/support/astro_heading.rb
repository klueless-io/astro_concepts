# frozen_string_literal: true

class AstroHeading
  attr_reader :depth, :slug, :text

  def initialize(depth, slug, text)
    @depth = depth
    @slug = slug
    @text = text
  end

  def to_h
    {
      depth: depth,
      slug: slug,
      text: text
    }
  end
end
