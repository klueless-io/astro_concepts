# frozen_string_literal: true

class AstroHeadingListBuilder
  attr_reader :headings

  def initialize
    @headings = []
  end

  def add(depth, text)
    @headings << AstroHeading.new(depth, text.to_underscore.gsub('_', '-'), text)

    self
  end

  def h1(text)
    add(1, text)
  end

  def h2(text)
    add(2, text)
  end

  def h3(text)
    add(3, text)
  end

  def h4(text)
    add(4, text)
  end

  def h5(text)
    add(5, text)
  end

  def h6(text)
    add(6, text)
  end

  def to_h
    headings.map(&:to_h)
  end
end
