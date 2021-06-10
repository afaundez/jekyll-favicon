# frozen_string_literal: true

module Jekyll
  module Favicon
    module Utils
      module Configuration
        # Favicon configuration merge logic
        module Merge
          def self.included(klass)
            klass.extend(ClassMethods)
          end

          def self.merge_multiple(left = nil, *right_and_or_rest)
            return left if right_and_or_rest.empty?

            right, *rest = right_and_or_rest
            merged = merge_pair left, right
            return merged if rest.empty?

            merge_multiple(merged, *rest)
          end

          def self.merge_pair(left, right)
            return right if !left || !right || !left.instance_of?(right.class)

            case right
            when Hash then merge_pair_hash left, right
            when Array then merge_pair_array left, right
            else right
            end
          end

          def self.merge_pair_hash(left_hash, right_hash)
            left_hash.merge(right_hash) do |_, left_value, right_value|
              merge_multiple left_value, right_value
            end
          end

          def self.merge_pair_array(left_array, right_array)
            joint_array = left_array + right_array
            joint_array.group_by { |map| merge_group map }
              .collect { |group, values| merge_collect group, values }
              .flatten
          end

          def self.merge_group(map, keys = %w[name dir])
            map.is_a?(Hash) ? map.values_at(*keys) : []
          end

          def self.merge_collect(group, values)
            group.first ? merge_multiple(*values) : values
          end

          # Merge configurations
          module ClassMethods
            def merge(left = nil, *right_and_or_rest)
              return left if right_and_or_rest.empty?

              right, *rest = right_and_or_rest
              merged = Merge.merge_pair left, right
              return merged if rest.empty?

              Merge.merge_multiple(merged, *rest)
            end
          end
        end
      end
    end
  end
end
