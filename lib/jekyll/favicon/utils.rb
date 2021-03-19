# frozen_string_literal: true

require 'mini_magick'

module Jekyll
  module Favicon
    # Favicon utils functions
    module Utils
      class << self
        def convert(input, output, options = {})
          MiniMagick::Tool::Convert.new do |convert|
            options = convert_svg_options input, convert, options
            convert << input
            convert_options convert, options
            convert << output
          end
        end

        def compact(compactable)
          case compactable
          when Hash, Array
            deep_compact(compactable) || compactable.class[]
          else
            compactable
          end
        end

        def find_all(findable, target)
          findable.each_with_object([]) do |(key, value), memo|
            if key == target
              memo << value
            elsif value.is_a? Hash
              memo.push(*find_all(value, target))
            end
          end.compact.flatten
        end

        def merge(*mergeables)
          mergeables.inject({}) do |memo, mergeable|
            Jekyll::Utils.deep_merge_hashes memo, mergeable
          end
        end

        private

        def convert_options(convert, options)
          convert.flatten
          options.each do |option, value|
            convert.send option.to_sym, value
          end
        end

        def convert_svg_options(input, convert, options)
          return options unless File.extname(input) == '.svg'

          return options unless (backgound = options.delete('background'))

          backgound = 'none' if backgound == 'transparent'
          convert.background backgound
          options
        end

        def deep_compact(compactable)
          case compactable
          when Hash
            compact_hash compactable
          when Array
            compact_array compactable
          else
            compactable
          end
        end

        def compact_hash(hash)
          compacted_hash = hash.each_with_object({}) do |(key, value), memo|
            next unless (compacted = deep_compact(value))

            memo[key] = compacted
          end
          compacted_hash.empty? ? nil : compacted_hash.compact
        end

        def compact_array(array)
          compacted_array = array.each_with_object([]) do |value, memo|
            next unless (compacted = deep_compact(value))

            memo << compacted
          end
          compacted_array.empty? ? nil : compacted_array.compact
        end
      end
    end
  end
end
