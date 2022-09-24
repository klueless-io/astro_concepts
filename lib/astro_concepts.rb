# frozen_string_literal: true

require_relative 'astro_concepts/version'
require_relative 'astro_concepts/heading'
require_relative 'astro_concepts/toc_builder'

module AstroConcepts
  # raise AstroConcepts::Error, 'Sample message'
  Error = Class.new(StandardError)

  # Your code goes here...
end

if ENV.fetch('KLUE_DEBUG', 'false').downcase == 'true'
  namespace = 'AstroConcepts::Version'
  file_path = $LOADED_FEATURES.find { |f| f.include?('astro_concepts/version') }
  version   = AstroConcepts::VERSION.ljust(9)
  puts "#{namespace.ljust(35)} : #{version.ljust(9)} : #{file_path}"
end
