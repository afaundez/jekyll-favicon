# frozen_string_literal: true

require 'rexml/document'

module Jekyll
  module Favicon
    module Utils
      # Favicon configuration for include
      module Configuration
        def self.included(klass)
          klass.extend(ClassMethods)
        end

        # Favicon Configuration utils functions
        module ClassMethods
          def compact(compactable)
            case compactable
            when Hash, Array then compact_deep(compactable) || compactable.class[]
            else compactable
            end
          end

          def except(hash, *keys)
            hash.reject { |key, _| keys.include? key }
          end

          def merge(left = nil, *right_and_or_rest)
            return left if right_and_or_rest.empty?

            right, *rest = right_and_or_rest
            merged = merge_pair left, right
            return merged if rest.empty?

            merge(merged, *rest)
          end

          private

          def compact_deep(compactable)
            case compactable
            when Hash then compact_hash compactable
            when Array then compact_array compactable
            else compactable
            end
          end

          def compact_hash(hash)
            compacted_hash = hash.each_with_object({}) do |(key, value), memo|
              next unless (compacted = compact_deep(value))

              memo[key] = compacted
            end
            compact_shallow compacted_hash
          end

          def compact_array(array)
            compacted_array = array.each_with_object([]) do |value, memo|
              next unless (compacted = compact_deep(value))

              memo << compacted
            end
            compact_shallow compacted_array
          end

          # :reek:UtilityFunction
          def compact_shallow(compactable)
            compactable.empty? ? nil : compactable.compact
          end

          def merge_pair(left, right)
            return right if !left || !right || !left.instance_of?(right.class)

            case right
            when Hash then merge_pair_hash left, right
            when Array then merge_pair_array left, right
            else right
            end
          end

          def merge_pair_hash(left_hash, right_hash)
            left_hash.merge(right_hash) do |_, left_value, right_value|
              merge left_value, right_value
            end
          end

          # :reek:UtilityFunction
          def merge_pair_array(left_array, right_array)
            (left_array + right_array).group_by { |map| map.is_a?(Hash) ? map.values_at('name', 'dir') : [] }
                                      .collect { |group, values| group.first ? merge(*values) : values }
                                      .flatten
          end
        end
      end
    end
  end
end
