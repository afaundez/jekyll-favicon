# frozen_string_literal: true

module Jekyll
  module Favicon
    module Utils
      module Configuration
        # Favicon configuration patch logic
        module Patch
          def self.included(klass)
            klass.extend(ClassMethods)
          end

          def self.patch_unknown(value_or_values, &block)
            patch_method = case value_or_values
                           when Array then :patch_array
                           when Hash then :patch_hash
                           when Symbol, String then :patch_value
                           else return value_or_values
            end
            send patch_method, value_or_values, &block
          end

          def self.patch_array(values, &block)
            values.collect { |value| patch_unknown value, &block }
          end

          def self.patch_hash(values, &block)
            values.transform_values { |value| patch_unknown value, &block }
          end

          def self.patch_value(value, &block)
            block.call patch_value_string_symbol(value)
          end

          def self.patch_value_string_symbol(value)
            value.to_s.start_with?(":") ? value[1..].to_sym : value
          end

          # Patch configuration with the block provided
          module ClassMethods
            def patch(value_or_values, &block)
              Patch.patch_unknown value_or_values, &block
            end
          end
        end
      end
    end
  end
end
