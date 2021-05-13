# frozen_string_literal: true

require 'jekyll/favicon/utils/convert'
require 'jekyll/favicon/utils/tag'

module Jekyll
  module Favicon
    # Favicon utils functions
    module Utils
      include Favicon::Utils::Convert
      include Favicon::Utils::Tag

      def self.except(hash, *keys)
        hash.reject { |key, _| keys.include? key }
      end

      def self.pathname(*paths)
        Pathname.new(File.join(*paths.compact)).cleanpath.to_s
      end

      def self.string_symbol(value)
        value.to_s.start_with?(':') ? value[1..-1].to_sym : value
      end

      class << self
        def compact(compactable)
          case compactable
          when Hash, Array then deep_compact(compactable) || compactable.class[]
          else compactable
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

        def merge_pair_hash(left_hash, right_hash)
          left_hash.merge(right_hash) do |_, left_value, right_value|
            merge left_value, right_value
          end
        end

        def merge_pair_array(left_array, right_array)
          (left_array + right_array).group_by { |map| map.is_a?(Hash) ? map.values_at('name', 'dir') : [] }
                                    .collect { |group, values| group.first ? merge(*values) : values }
                                    .flatten
        end

        def merge_pair(left, right)
          return right if !left || !right || !left.instance_of?(right.class)

          case right
          when Hash then merge_pair_hash left, right
          when Array then merge_pair_array left, right
          else right
          end
        end

        def merge(left = nil, *right_and_or_rest)
          return left if right_and_or_rest.empty?

          right, *rest = right_and_or_rest
          merged = merge_pair left, right
          return merged if rest.empty?

          merge(merged, *rest)
        end

        private

        def deep_compact(compactable)
          case compactable
          when Hash then compact_hash compactable
          when Array then compact_array compactable
          else compactable
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
