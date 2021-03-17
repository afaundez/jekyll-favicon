# frozen_string_literal: true

module Jekyll
  module Favicon
    # Favicon utils functions
    module Utils
      class << self
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

        private

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
